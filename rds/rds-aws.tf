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

variable "db_name" {
	type    = string
	default = "appdb"
}

variable "db_username" {
	type    = string
	default = "appadmin"
}

variable "db_password" {
	type      = string
	sensitive = true

	validation {
		condition     = length(var.db_password) >= 8 && length(var.db_password) <= 128 && !can(regex("[/@\"\\s]", var.db_password))
		error_message = "db_password deve ter 8-128 caracteres e nao pode conter '/', '@', aspas duplas ou espaco."
	}
}

variable "allowed_cidr" {
	type    = string
	default = "136.226.140.83/32"
}

provider "aws" {
	region = var.aws_region
}

data "aws_vpc" "default" {
	default = true
}

data "aws_subnets" "default" {
	filter {
		name   = "vpc-id"
		values = [data.aws_vpc.default.id]
	}
}

resource "aws_db_subnet_group" "main" {
	name       = "rds-free-tier-subnet-group"
	subnet_ids = data.aws_subnets.default.ids

	tags = {
		Name      = "rds-free-tier-subnet-group"
		ManagedBy = "Terraform"
	}
}

resource "aws_security_group" "rds" {
	name        = "rds-free-tier-sg"
	description = "Permite conexao ao RDS pela porta 5432"
	vpc_id      = data.aws_vpc.default.id

	ingress {
		description = "PostgreSQL from allowed CIDR"
		from_port   = 5432
		to_port     = 5432
		protocol    = "tcp"
		cidr_blocks = [var.allowed_cidr]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name      = "rds-free-tier-sg"
		ManagedBy = "Terraform"
	}
}

resource "aws_db_instance" "free_tier" {
	identifier             = "rds-free-tier-postgres"
	engine                 = "postgres"
	engine_version         = "17"
	instance_class         = "db.t3.micro"
	allocated_storage      = 20
	max_allocated_storage  = 20
	storage_type           = "gp2"
	storage_encrypted      = true
	db_name                = var.db_name
	username               = var.db_username
	password               = var.db_password
	port                   = 5432
	publicly_accessible    = true
	multi_az               = false
	db_subnet_group_name   = aws_db_subnet_group.main.name
	vpc_security_group_ids = [aws_security_group.rds.id]
	backup_retention_period = 0
	apply_immediately      = true
	deletion_protection    = false
	skip_final_snapshot    = true

	tags = {
		Name      = "rds-free-tier-postgres"
		ManagedBy = "Terraform"
	}
}

output "rds_endpoint" {
	value       = aws_db_instance.free_tier.address
	description = "Endpoint do banco RDS"
}

output "rds_port" {
	value       = aws_db_instance.free_tier.port
	description = "Porta do banco RDS"
}
