variable "host" {
  description = "The hostname of the Proxmox host"
  type        = string
}

variable "pm_node" {
  description = "The name of the Proxmox node"
  type        = string
}

variable "pm_api_token_secret" {
  description = "The secret for the Proxmox API token"
  type        = string
}

variable "pm_api_token_id" {
  description = "The ID for the Proxmox API token"
  type        = string
}

variable "pm_tls_insecure" {
  description = "Whether to skip TLS verification for the Proxmox API"
  type        = bool
  default     = true
}

variable "pm_vm_template" {
  description = "The template to use for the VMs"
  type        = string
  default     = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
}

variable "pm_vm_net_ipbase" {
  description = "The IP base to use for the VMs"
  type        = string
  default     = "192.168.0"
}

variable "pm_vm_hostname_base" {
  description = "The base hostname to use for the VMs"
  type        = string
  default     = "pve-kube-test"
}
