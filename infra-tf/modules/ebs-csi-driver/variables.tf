variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  type        = string
  default     = "ebs-csi-controller-sa"
}

variable "release_name" {
  type        = string
  default     = "ebs-csi-driver"
}

variable "chart_version" {
  type        = string
  default     = "2.45.1"
}

variable "oidc_provider" {
  type        = string
  description = "OIDC provider URL (like `oidc.eks.eu-west-1.amazonaws.com/id/ABCDEF`)"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for IAM role/policy names"
}
