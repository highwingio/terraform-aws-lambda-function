output "function_arn" {
  value = module.lambda_function.lambda_function_arn
}

output "qualified_function_arn" {
  value = module.lambda_function.lambda_function_qualified_arn
}

output "function_name" {
  value = module.lambda_function.lambda_function_name
}

output "function_version" {
  value = module.lambda_function.lambda_function_version
}

output "lambda_role_arn" {
  value = module.lambda_function.lambda_role_arn
}

output "lambda_role_name" {
  value = module.lambda_function.lambda_role_name
}
