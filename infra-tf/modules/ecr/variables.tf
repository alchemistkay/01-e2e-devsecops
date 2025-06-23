variable "repository_names" {
  type        = list(string)
  description = "List of ECR repository names to create"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace where service account is deployed"
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes Service Account name for ECR access"
}

variable "oidc_provider" {
  type        = string
  description = "OIDC provider URL (without ARN)"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for IAM resources"
}
