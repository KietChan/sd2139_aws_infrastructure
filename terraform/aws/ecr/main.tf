provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "k_ecr" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

output "ecr_repo_id" {
  value = aws_ecr_repository.k_ecr.id
}
