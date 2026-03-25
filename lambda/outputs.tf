output "function_name" {
  value = aws_lambda_function.main.function_name
}

output "function_arn" {
  value = aws_lambda_function.main.arn
}

output "invoke_cli" {
  value = "aws lambda invoke --function-name ${aws_lambda_function.main.function_name} --payload '{}' response.json"
}