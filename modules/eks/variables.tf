variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "eks-lab-min"
}

variable "kubernetes_version" {
  type    = string
  default = "1.31"
}

variable "node_group_name" {
  type    = string
  default = "lab-ng"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "node_capacity_type" {
  type    = string
  default = "SPOT"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "desired_size" {
  type    = number
  default = 1

  validation {
    condition     = var.desired_size >= 0 && var.desired_size <= 2
    error_message = "desired_size must be between 0 and 2 for lab cost guardrails."
  }
}

variable "min_size" {
  type    = number
  default = 0

  validation {
    condition     = var.min_size >= 0 && var.min_size <= 2
    error_message = "min_size must be between 0 and 2 for lab cost guardrails."
  }
}

variable "max_size" {
  type    = number
  default = 1

  validation {
    condition     = var.max_size >= 1 && var.max_size <= 2
    error_message = "max_size must be between 1 and 2 for lab cost guardrails."
  }
}

variable "node_disk_size" {
  type    = number
  default = 20
}

variable "public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "create_cost_budget" {
  type    = bool
  default = false
}

variable "monthly_budget_limit_usd" {
  type    = string
  default = "10"
}

variable "budget_alert_email" {
  type    = string
  default = "eng.pauloaragao@gmail.com"
}
