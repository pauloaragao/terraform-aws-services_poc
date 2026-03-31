output "cluster_name" {
  value       = aws_eks_cluster.main.name
  description = "EKS cluster name"
}

output "cluster_arn" {
  value       = aws_eks_cluster.main.arn
  description = "EKS cluster ARN"
}

output "node_group_name" {
  value       = aws_eks_node_group.main.node_group_name
  description = "Node group name"
}

output "update_kubeconfig" {
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
  description = "Command to configure kubectl for this cluster"
}

output "cost_guardrail_tip" {
  value       = "For lower cost, set desired_size=0 when idle and run terraform apply."
  description = "How to reduce costs when the cluster is not in use"
}
