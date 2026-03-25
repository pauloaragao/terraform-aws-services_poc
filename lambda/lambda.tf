terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.37"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "function_name" {
  type    = string
  default = "my-python-lambda"
}

provider "aws" {
  region = var.aws_region
}

# --- Package the Python source code into a zip ---

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda_package.zip"
}

# --- IAM role for Lambda execution ---

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${var.function_name}-exec-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# --- Lambda function (Free Tier optimized) ---
# Free Tier: 1M requests/month + 400,000 GB-seconds/month (permanent)
# 128 MB x 10s = 1.28 GB-seconds per invocation
# ~312,500 invocations/month before any charge

resource "aws_lambda_function" "main" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_exec.arn
  runtime          = "python3.12"
  handler          = "handler.lambda_handler"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # Minimum memory = minimum GB-seconds consumed
  memory_size = 128

  # Lower timeout reduces GB-seconds per invocation
  timeout = 10

  # Graviton2 (arm64): same Free Tier, 20% cheaper if exceeded
  architectures = ["arm64"]

  environment {
    variables = {
      ENV = "dev"
    }
  }
}

# --- CloudWatch Log Group with 7-day retention ---

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}

# --- Outputs ---

output "function_name" {
  value = aws_lambda_function.main.function_name
}

output "function_arn" {
  value = aws_lambda_function.main.arn
}

output "invoke_cli" {
  value = "aws lambda invoke --function-name ${aws_lambda_function.main.function_name} --payload '{}' response.json"
}
