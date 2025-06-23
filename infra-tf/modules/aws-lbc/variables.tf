variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace for the controller"
}

variable "service_account_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Name of the service account for LBC"
}

variable "release_name" {
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "chart_version" {
  type        = string
  default     = "1.13.3"
}

variable "oidc_provider" {
  type        = string
  description = "OIDC provider URL"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN"
}

variable "name_prefix" {
  type        = string
  description = "Name prefix for IAM roles and policies"
}
