output "function_name" {
  description = "Name of the created Lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "function_arn" {
  description = "ARN of the created/updated Lambda function"
  value       = aws_lambda_function.lambda.arn
}

output "function_version" {
  description = "Version of the created/updated Lambda function"
  value       = aws_lambda_function.lambda.version
}

output "function_invoke_arn" {
  description = "ARN for invoking the created Lambda function"
  value       = aws_lambda_function.lambda.invoke_arn
}
