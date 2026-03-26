# AWS EKS Cluster Module
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

variable "cluster_name"    { type = string }
variable "cluster_version" { type = string, default = "1.29" }
variable "vpc_id"          { type = string }
variable "subnet_ids"      { type = list(string) }
variable "environment"     { type = string }

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

output "cluster_endpoint"   { value = aws_eks_cluster.main.endpoint }
output "cluster_name"       { value = aws_eks_cluster.main.name }
output "cluster_version"    { value = aws_eks_cluster.main.version }
