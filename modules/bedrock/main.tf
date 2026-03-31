resource "aws_iam_role" "bedrock_agent" {
  name_prefix        = "AmazonBedrockExecutionRoleForAgents_"
  assume_role_policy = data.aws_iam_policy_document.agent_trust.json
}

resource "aws_iam_role_policy" "bedrock_agent" {
  name   = "bedrock-agent-model-access"
  role   = aws_iam_role.bedrock_agent.id
  policy = data.aws_iam_policy_document.agent_permissions.json
}

resource "aws_bedrockagent_agent" "main" {
  agent_name                  = var.agent_name
  agent_resource_role_arn     = aws_iam_role.bedrock_agent.arn
  foundation_model            = var.foundation_model
  instruction                 = var.agent_instruction
  idle_session_ttl_in_seconds = var.idle_session_ttl_in_seconds
  prepare_agent               = true
}

resource "aws_bedrockagent_agent_alias" "main" {
  agent_alias_name = var.agent_alias_name
  agent_id         = aws_bedrockagent_agent.main.agent_id
  description      = "Alias for ${var.agent_name}"
}