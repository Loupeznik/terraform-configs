terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.49.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "vm" {
  name        = var.name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  backups     = var.enable_backups
  ssh_keys    = var.ssh_keys

  public_net {
    ipv4_enabled = var.ipv4_enabled
    ipv6_enabled = var.ipv6_enabled
  }
}
