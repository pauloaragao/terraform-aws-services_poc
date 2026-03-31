output "agent_id" {
  description = "Unique identifier of the Bedrock agent."
  value       = aws_bedrockagent_agent.main.agent_id
}

output "agent_arn" {
  description = "ARN of the Bedrock agent."
  value       = aws_bedrockagent_agent.main.agent_arn
}

output "agent_alias_id" {
  description = "Unique identifier of the Bedrock agent alias."
  value       = aws_bedrockagent_agent_alias.main.agent_alias_id
}

output "agent_alias_arn" {
  description = "ARN of the Bedrock agent alias."
  value       = aws_bedrockagent_agent_alias.main.agent_alias_arn
}

output "foundation_model" {
  description = "Foundation model configured for the agent."
  value       = var.foundation_model
}