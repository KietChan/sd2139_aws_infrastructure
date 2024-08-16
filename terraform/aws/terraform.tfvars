aws_region    = "ap-southeast-1"
ami_id        = "ami-060e277c0d4cce553"  # Ubuntu 2024, AMD-64
# instance_type = "t2.micro" # To slow, might crashed
instance_type = "t2.medium"
availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# ECR
ecr_repository_name_frontend = "sd2139_ecr_repo_frontend"
ecr_repository_name_backend = "sd2139_ecr_repo_backend"

# EKS
eks_instance_type   = "t2.medium"
