output "eks_name" {
  value = aws_eks_cluster.this.name
}

output "openid_provider_arn" {
  value = aws_iam_openid_connect_provider.this[0].arn
}


output "node_group_role_arn" {
  value = aws_iam_role.nodes.arn
}

output "openid_provider_url" {
  value = aws_iam_openid_connect_provider.this[0].url
}

output "private_key" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}