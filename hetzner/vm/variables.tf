variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "name" {
  type        = string
  description = "Server name"
}

variable "image" {
  type        = string
  description = "VM image"
  default     = "ubuntu-24.04"
}

variable "server_type" {
  type        = string
  description = "Server type"
  default     = "cx22"
}

variable "ipv4_enabled" {
  type        = bool
  description = "Enable IPv4"
  default     = false
}

variable "ipv6_enabled" {
  type        = bool
  description = "Enable IPv6"
  default     = true
}

variable "ssh_keys" {
  type        = list(string)
  description = "SSH keys to add to the server"
  default     = []
}

variable "location" {
  type        = string
  description = "Datacenter name"
  default     = "fsn1"
}

variable "enable_backups" {
  type        = bool
  description = "Enable backups"
  default     = false
}
