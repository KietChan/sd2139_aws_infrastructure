variable "aws_region" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "eks_instance_type" {
  type = string
}
