provider "aws" {
  region = var.aws_region
}

# VPC
module "vpc" {
  source = "./vpc"
  availability_zones = var.availability_zones
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

# RSA
module "rsa" {
  source = "./rsa"
}
output "private_key_pem" {
  value = module.rsa.private_key_pem
  sensitive = true
}

# ECR
module "ecr" {
  source = "./ecr"
  
  region =  var.aws_region
  ecr_repository_name = var.ecr_repository_name
}
output "ecr_repo_id" {
  value = module.ecr.ecr_repo_id
}


# EC2
module "ec2" {
  source = "./ec2"
  aws_region      = var.aws_region
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_ids
  key_name        = module.rsa.key_name
}
output "instance_id" {
  value = module.ec2.instance_id
}
