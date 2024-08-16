provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "k_ecr_fe" {
  name                 = var.ecr_repository_name_frontend
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "k_ecr_be" {
  name                 = var.ecr_repository_name_backend
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}


output "ecr_repo_url_fe" {
  value = aws_ecr_repository.k_ecr_fe.repository_url
}
output "ecr_repo_url_be" {
  value = aws_ecr_repository.k_ecr_be.repository_url
}
