variable "aws_region" {
  description = "AWS region para todos os módulos"
  type        = string
  default     = "us-east-1"
}

# --- Flags de deploy ---

variable "deploy_ec2" {
  description = "Habilita o módulo EC2"
  type        = bool
  default     = false
}

variable "deploy_rds" {
  description = "Habilita o módulo RDS"
  type        = bool
  default     = false
}

variable "deploy_lambda" {
  description = "Habilita o módulo Lambda"
  type        = bool
  default     = false
}

variable "deploy_bedrock" {
  description = "Habilita o módulo Bedrock"
  type        = bool
  default     = false
}

variable "deploy_eks" {
  description = "Habilita o módulo EKS"
  type        = bool
  default     = false
}

# --- EC2 ---

variable "ec2_instance_name" {
  description = "Nome da instância EC2"
  type        = string
  default     = "example-dev"
}

variable "ec2_instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

# --- RDS ---

variable "rds_db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "appdb"
}

variable "rds_db_username" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "appadmin"
}

variable "rds_db_password" {
  description = "Senha do banco de dados (obrigatória quando deploy_rds = true)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "rds_allowed_cidr" {
  description = "CIDR permitido para acesso ao RDS"
  type        = string
  default     = "136.226.140.83/32"
}

# --- Lambda ---

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "my-python-lambda"
}

# --- Bedrock ---

variable "bedrock_agent_name" {
  description = "Nome do Bedrock Agent"
  type        = string
  default     = "example-bedrock-agent"
}

variable "bedrock_agent_alias_name" {
  description = "Nome do alias do Bedrock Agent"
  type        = string
  default     = "dev"
}

variable "bedrock_foundation_model" {
  description = "Model ID do Bedrock"
  type        = string
  default     = "amazon.nova-lite-v1:0"
}

variable "bedrock_agent_instruction" {
  description = "Instrução do Bedrock Agent (mínimo 40 caracteres)"
  type        = string
  default     = "You are a helpful assistant that answers user questions clearly and objectively."
}

# --- EKS ---

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "eks-lab-min"
}

variable "eks_node_capacity_type" {
  description = "Tipo de capacidade dos nós (SPOT ou ON_DEMAND)"
  type        = string
  default     = "SPOT"
}

variable "eks_desired_size" {
  description = "Número desejado de nós (0-2)"
  type        = number
  default     = 1
}

variable "eks_min_size" {
  description = "Mínimo de nós (0-2)"
  type        = number
  default     = 0
}

variable "eks_max_size" {
  description = "Máximo de nós (1-2)"
  type        = number
  default     = 1
}
