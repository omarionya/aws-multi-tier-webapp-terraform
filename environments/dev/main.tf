provider "aws" {
  region  = "us-east-1"
  profile = "aws-lab"
}

#VPC MODULE

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]

  public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs    = ["10.0.3.0/24", "10.0.4.0/24"]
  private_db_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = {
    Environment = "dev"
    Poject      = "multi-tier-webapp"
  }

}

#security group module

module "sg" {
  source = "../../modules/security-groups"

  vpc_id = module.vpc.vpc_id

  tags = {
    Evironment = "dev"
  }
}

# ALB MODULE

module "alb" {
  source            = "../../modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id

  tags = {
    Environment = "dev"
  }
}

#EC2 ASG MODULE

module "ec2-asg" {

  source             = "../../modules/ec2-asg"
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.sg.app_sg_id
  target_group_arn   = module.alb.target_group_arn

  instance_type    = "t3.micro"
  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  tags = {
    Environment = "dev"
  }
}

# RDS MODULE
module "rds" {
  source        = "../../modules/rds"
  db_subnet_ids = module.vpc.private_db_subnet_ids
  db_sg_id      = module.sg.db_sg_id

  db_name     = "appdb"
  db_username = "admin"
  db_password = var.db_password

  tags = {
    Environment = "dev"
  }
}