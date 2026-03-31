variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "agent_name" {
  type    = string
  default = "example-bedrock-agent"
}

variable "agent_alias_name" {
  type    = string
  default = "dev"
}

variable "foundation_model" {
  type    = string
  default = "amazon.nova-lite-v1:0"
}

variable "agent_instruction" {
  type        = string
  description = "Instruction used by the Bedrock agent. Bedrock requires at least 40 characters when prepare_agent is true."
  default     = "You are a helpful assistant that answers user questions clearly and objectively."

  validation {
    condition     = length(var.agent_instruction) >= 40
    error_message = "agent_instruction must have at least 40 characters."
  }
}

variable "idle_session_ttl_in_seconds" {
  type    = number
  default = 600
}