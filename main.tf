module "vpc" {
  source             = "./modules/vpc"
  app_name           = var.app_name
  availability_zones = var.availability_zones
  cidr_block         = var.cidr_block
  env                = var.env
  public_subnets     = var.public_subnets
}

module "alb_security_group" {
  source        = "./modules/sg"
  name          = "ecs-alb-security-group"
  description   = "ecs-alb-security-group"
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 8082
      to_port     = 8082
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs_service_sg"
  description = "ecs_service_sg"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb_sg_inbound_rule" {
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_service_sg.id
  source_security_group_id = module.alb_security_group.security_group_id
  to_port                  = 80
  type                     = "ingress"
}

resource "aws_security_group_rule" "alb_sg_outbound_rule" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Full outbound access"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ecs_service_sg.id
  to_port           = 0
  type              = "egress"
}


module "alb" {
  source              = "./modules/alb"
  app_name            = var.app_name
  alb_security_groups = [module.alb_security_group.security_group_id]
  public_subnets      = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
}

module "iam" {
  source                        = "./modules/iam"
}

module "ecs_cook_service" {
  source                 = "./modules/ecs"
  cluster_name           = "cook"
  alb                    = module.alb.alb_arn
  cook_target_group      = module.alb.blue_target_group
  public_subnets         = module.vpc.public_subnet_ids
  cook_security_group_id = aws_security_group.ecs_service_sg.id
  task_role_arn          = module.iam.ecs_task_role_arn
}

module "pipeline" {
  source                  = "./modules/cicd"
  account                 = data.aws_caller_identity.current.account_id
  pipeline_name          = "preview-service"

  #Source Stage
  branch_name            = "master"
  repository_name        = "cook-service"
  source_repository_type = "codecommit"

  #Build Stage
  project_name = "preview-service"
  build_environment_variables = [
    { name = "REGION", value = "us-east-1", type = "PLAINTEXT" },
    { name = "ACCOUNT", value = data.aws_caller_identity.current.account_id, type = "PLAINTEXT" },
    { name = "ECR_REPO", value = "", type = "PLAINTEXT" }
  ]

  #Deploy Stage
  alb_prod_listener_arn   = module.alb.blue_listener_arn
  alb_test_listener_arn   = module.alb.test_listener_arn
  alb_target_group_one    = module.alb.blue_target_group_name
  alb_target_group_second = module.alb.green_target_group_name
  application_name        = "preview-service"
  ecs_cluster_name        = module.ecs_cook_service.ecs_cluster_name
  ecs_service_name        = module.ecs_cook_service.ecs_service_name
}

output "albarns" {
  value = module.alb.test_listener_arn
}