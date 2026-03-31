# Output com ID e comando de conexão SSM
output "instance_id" {
  value       = aws_instance.example.id
  description = "ID da instância EC2"
}

output "instance_public_ip" {
  value       = aws_instance.example.public_ip
  description = "IP público da instância"
}

output "ssm_start_session" {
  value       = "aws ssm start-session --target ${aws_instance.example.id}"
  description = "Comando para conectar via SSH (Session Manager)"
}
