terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
# terraform {
#   backend "s3" {
#     bucket = "8586-terraform-state"
#     region = "us-east-1"
#     key    = "terraform.tfstate"
#   }
# }

module "vpc" {
  source       = "./VPC"
}

module "SecurityGroups" {
  source       = "./SecurityGroups"
  vpc_id       = module.vpc.vpc_id

}

module "Instance" {
  source       = "./Instance"


  PUBLIC_SUBNET_ID = module.vpc.PUBLIC_SUBNET_ID
  INSTANCE_SG_ID   = module.SecurityGroups.INSTANCE_SG_ID
}

module "RDS" {
  source              = "./RDS"
  PRIVATE_SUBNET_ID_1 = module.vpc.PRIVATE_SUBNET_ID_1
  PRIVATE_SUBNET_ID_2 = module.vpc.PRIVATE_SUBNET_ID_2

  rds_security_group_id = module.SecurityGroups.rds_security_group_id

}