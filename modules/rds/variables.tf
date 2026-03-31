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