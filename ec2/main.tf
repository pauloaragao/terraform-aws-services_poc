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

