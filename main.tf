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

resource "aws_s3_bucket" "codepipeline_artifact_bucket" {
  lifecycle {
    prevent_destroy = false
  }
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
  codepipeline_artifacts_bucket = aws_s3_bucket.codepipeline_artifact_bucket.id
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

module "codebuild_project" {
  source           = "./modules/codebuild"
  service_role_arn = module.iam.codebuild_role_arn
}

module "codedeploy" {
  source                      = "./modules/codedeploy"
  alb_listener_blue_arn       = module.alb.blue_listener_arn
  alb_listener_test_arn       = module.alb.test_listener_arn
  alb_target_group_blue_name  = module.alb.blue_target_group_name
  alb_target_group_green_name = module.alb.green_target_group_name
  codedeploy_service_role_arn = module.iam.codedeploy_role_arn
  ecs_cluster_name            = module.ecs_cook_service.ecs_cluster_name
  ecs_cook_service_name       = module.ecs_cook_service.ecs_service_name
}

module "codedeploy_lambda_hook" {
  source = "./modules/lambda"

  file_name          = "${path.module}/lambda/AfterAllowTestTrafficHook.zip"
  function_name      = "AfterAllowTestTrafficHook"
  handler            = "AfterAllowTestTrafficHook.handler"
  execution_role_arn = module.iam.lambda_execution_role_arn
  runtime            = "nodejs12.x"
}

module "codepipeline" {
  source                        = "./modules/codepipeline"
  codepipeline_role_arn         = module.iam.codepipeline_role_arn
  repository_name               = "cook-service"
  codepipeline_artifacts_bucket = aws_s3_bucket.codepipeline_artifact_bucket.id
  codebuild_project_name        = module.codebuild_project.codebuild_project_name

  codedeploy_app_name              = module.codedeploy.codedeploy_app_name
  codedeploy_deployment_group_name = module.codedeploy.codedeploy_deployment_group_name
}

