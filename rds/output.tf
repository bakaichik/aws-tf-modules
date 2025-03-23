output "rds_password" {
  value     = aws_rds_cluster.this.master_password
  sensitive = true
}

output "rds_master_username" {
  value = aws_rds_cluster.this.master_username
}
