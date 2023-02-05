variable "region" {
  description = "Deployment region"
  type        = string
  default     = "northeurope"
}

variable "resource_id_suffix" {
  description = "Suffix for resource identifiers"
  default     = "dz-app-test-northeurope-01"
}
