variable "region" {
  description = "Deployment region"
  type        = string
}

variable "resource_id_suffix" {
  description = "Suffix for resource identifiers"
  default     = "dz-azfunctions-test-01"
}
