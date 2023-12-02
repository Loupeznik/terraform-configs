terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">2.9.0"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "${var.host}/api2/json"
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure
}

resource "proxmox_lxc" "ct-master" {
  target_node  = var.pm_node
  hostname     = "${var.pm_vm_hostname_base}-master"
  ostemplate   = var.pm_vm_template
  password     = "kubeadmin"
  unprivileged = true
  onboot       = true
  start        = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.pm_vm_net_ipbase}.210/32"
  }
}

resource "proxmox_lxc" "ct-slave-0" {
  target_node  = var.pm_node
  hostname     = "${var.pm_vm_hostname_base}-slave-0"
  ostemplate   = var.pm_vm_template
  password     = "kubeadmin"
  unprivileged = true
  onboot       = true
  start        = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.pm_vm_net_ipbase}.211/32"
  }
}

resource "proxmox_lxc" "ct-slave-1" {
  target_node  = var.pm_node
  hostname     = "${var.pm_vm_hostname_base}-slave-1"
  ostemplate   = var.pm_vm_template
  password     = "kubeadmin"
  unprivileged = true
  onboot       = true
  start        = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.pm_vm_net_ipbase}.212/32"
  }
}
