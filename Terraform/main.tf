# Configure the AWS provider block. This tells Terraform which cloud provider to use and 
# how to authenticate (access key, secret key, and region) when provisioning resources.
# Note: Hardcoding credentials is not recommended for production use. Instead, use environment variables
# or IAM roles to manage credentials securely.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "VPC" {
  source = "./modules/VPC"
}

module "EC2" {
  source = "./modules/EC2"
  vpc_id = module.VPC.vpc_id
  public_subnet_id_1 = module.VPC.public_subnet_id_1
  public_subnet_id_2 = module.VPC.public_subnet_id_2
  private_subnet_id_1 = module.VPC.private_subnet_id_1
  private_subnet_id_2 = module.VPC.private_subnet_id_2
  backend_security_group_id = module.VPC.backend_security_group_id
}

# module "Load" {
#   source = "./modules/LOAD"
#   vpc_id = module.VPC.vpc_id
#   public_subnet_id_1 = module.VPC.public_subnet_id_1
#   public_subnet_id_2 = module.VPC.public_subnet_id_2
#   instance_id_1 = module.EC2.instance_id_1
#   instance_id_2 = module.EC2.instance_id_2
# }

# module "RDS" {
#   source = "./modules/RDS"
#   vpc_id = module.VPC.vpc_id
#   private_subnet_id = module.VPC.private_subnet_id_1
#   private_subnet_id_2 = module.VPC.private_subnet_id_2
#   backend_security_group_id = module.VPC.backend_security_group_id
# }

