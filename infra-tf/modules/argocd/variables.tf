variable "namespace" {
  description = "Namespace to install ArgoCD"
  type        = string
  default     = "argocd"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Version of ArgoCD Helm chart"
  type        = string
  default     = "5.51.6" # adjust as needed
}

variable "values" {
  description = "Custom Helm values for ArgoCD"
  type        = any
  default     = {}
}
