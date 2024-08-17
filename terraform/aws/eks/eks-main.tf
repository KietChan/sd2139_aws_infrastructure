# Configure the AWS provider with the specified region
provider "aws" {
  region = var.aws_region
}

# Create an EKS cluster with the specified name and role
resource "aws_eks_cluster" "k_eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

# Create an IAM role for the EKS cluster to allow EKS to manage AWS resources
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the AmazonEKSClusterPolicy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach the AmazonEKSServicePolicy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# Create an EKS node group to manage the worker nodes for the EKS cluster
resource "aws_eks_node_group" "k_eks_node_group" {
  cluster_name    = aws_eks_cluster.k_eks_cluster.name
  node_group_name = "my-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = [var.eks_instance_type]
}

# Create an IAM role for the EKS node group to allow EC2 instances to interact with AWS services
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks_node_group_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the AmazonEKSWorkerNodePolicy to the EKS node group role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach the AmazonEKS_CNI_Policy to the EKS node group role for networking
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Attach the AmazonEC2ContainerRegistryReadOnly policy to the EKS node group role for read-only access to ECR
resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# Output the EKS cluster ID
output "cluster_id" {
  value = aws_eks_cluster.k_eks_cluster.id
}

# Output the EKS cluster endpoint
output "cluster_endpoint" {
  value = aws_eks_cluster.k_eks_cluster.endpoint
}

# Output the EKS cluster certificate authority data
output "cluster_certificate_authority" {
  value = aws_eks_cluster.k_eks_cluster.certificate_authority[0].data
}
