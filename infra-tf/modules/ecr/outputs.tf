output "ecr_repositories" {
  value       = module.repos.ecr_repositories
  description = "Map of created ECR repositories"
}

output "iam_role_name" {
  value       = module.access.iam_role_name
  description = "IAM role name for ECR access"
}

output "service_account_name" {
  value       = module.access.service_account_name
  description = "Service account name used for IRSA"
}
