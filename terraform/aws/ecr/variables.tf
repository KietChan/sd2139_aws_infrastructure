variable "region" {
  description = "ECR Region"
  type        = string
}

variable "ecr_repository_name_frontend" {
  description = "ECR Repository Name for front end project"
  type        = string
}

variable "ecr_repository_name_backend" {
  description = "ECR Repository Name for backend project"
  type        = string
}
