variable "region" {
  description = "Deployment region"
  type        = string
  default     = "eu-west-1"
}

variable "resource_id_suffix" {
  description = "Suffix for resource identifiers"
  type        = string
  default     = "dz_kube_test_01"
}
