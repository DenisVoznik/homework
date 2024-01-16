terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-3"
  profile = "terraform"
}


module "ec2" {
  source             = "./ec2"
  instance_type      = "t3.micro"
  puplic_subnet_id   = module.networking.public_subnet_id
  private_subnet_id  = module.networking.private_subnet_id
  security_group_ids = [module.networking.security_group_ids]
}

module "networking" {
  source              = "./networking"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.101.0/24"
}
