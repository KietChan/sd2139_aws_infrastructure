variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs where the EC2 instance will be created"
  type        = list(string)
}

variable "key_name" {
  description = "<TODO>"
  type        = string
}
