output "rds_endpoint" {
  value       = aws_db_instance.free_tier.address
  description = "Endpoint do banco RDS"
}

output "rds_port" {
  value       = aws_db_instance.free_tier.port
  description = "Porta do banco RDS"
}