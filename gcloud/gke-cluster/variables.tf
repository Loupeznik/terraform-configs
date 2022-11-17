variable "project" {
  type        = string
  sensitive   = true
  description = "Project name"
}

variable "region" {
  description = "Deployment region"
  type        = string
}

variable "resource_id_suffix" {
  description = "Suffix for resource identifiers"
  default     = "dz-kube-test-01"
}
