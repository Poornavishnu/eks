output "eks_node_role_arn" {
  description = "The IAM role ARN for EKS worker nodes"
  value       = aws_iam_role.eks_node_role.arn
}