terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.37"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_name" {
  type    = string
  default = "example-dev"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

provider "aws" {
  region = var.aws_region
}

# Busca a AMI mais recente do Amazon Linux 2023
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Obtém a VPC padrão
data "aws_vpc" "default" {
  default = true
}

# Obtém as subnets da VPC padrão
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Role IAM para SSM (Session Manager)
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role-example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Anexa policy de SSM à role
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile para a EC2
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "ec2-ssm-profile-example"
  role = aws_iam_role.ec2_ssm_role.name
}

# Security Group (sem entrada pública; acesso via SSM)
resource "aws_security_group" "ec2_ssm" {
  name        = "ec2-ssm-only"
  description = "Sem entrada publica; acesso via SSM"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-ssm-security-group"
  }
}

# Instância EC2
resource "aws_instance" "example" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  vpc_security_group_ids      = [aws_security_group.ec2_ssm.id]
  associate_public_ip_address = true

  tags = {
    Name      = var.instance_name
    ManagedBy = "Terraform"
  }
}

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
