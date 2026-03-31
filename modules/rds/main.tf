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
  identifier              = "rds-free-tier-postgres"
  engine                  = "postgres"
  engine_version          = "17"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 20
  storage_type            = "gp2"
  storage_encrypted       = true
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = 5432
  publicly_accessible     = true
  multi_az                = false
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  backup_retention_period = 0
  apply_immediately       = true
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name      = "rds-free-tier-postgres"
    ManagedBy = "Terraform"
  }
}