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
}

variable "pm_vm_net_ipbase" {
  description = "The IP base to use for the VMs"
  type        = string
  default     = "192.168.0"
}

variable "pm_vm_hostname_base" {
  description = "The base hostname to use for the VMs"
  type        = string
  default     = "k8s-sbx-01-vm"
}

variable "pm_vm_count" {
  description = "The number of VMs to create"
  type        = number
  default     = 2
}

variable "pm_disk_name" {
  description = "The name of the disk storage"
  type        = string
  default     = "ssd-storage-1"
}

variable "ssh_key" {
  description = "The SSH public key to use for the VMs"
  type        = string
}

variable "pm_vm_cipassword" {
  description = "The password for the cloud-init user"
  type        = string
}
