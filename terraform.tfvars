account      = 793209430381
region       = "us-east-1"
app_name     = "ecs-bluegreen-poc"
env          = "dev"

#VPC configurations
cidr_block               = "10.10.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.10.50.0/24", "10.10.51.0/24"]
