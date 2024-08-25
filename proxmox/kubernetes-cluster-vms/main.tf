terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "${var.host}/api2/json"
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure
}

resource "proxmox_vm_qemu" "k8s-sbx-01" {
  count       = var.pm_vm_count
  name        = "${var.pm_vm_hostname_base}-${count.index + 1}"
  target_node = var.pm_node
  vmid        = "800${count.index + 1}"
  clone       = var.pm_vm_template
  os_type     = "cloud-init"
  cpu         = "kvm64"
  cores       = 2
  sockets     = 1
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  onboot      = true

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "10G"
          storage = var.pm_disk_name
        }
      }
    }

    ide {
      ide2 {
        cloudinit {
          storage = var.pm_disk_name
        }
      }
    }
  }

  boot = "order=scsi0;ide2"

  network {
    model     = "virtio"
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
  }

  ipconfig0  = "ip=${var.pm_vm_net_ipbase}.${54 + count.index}/24,gw=${var.pm_vm_net_ipbase}.1"
  ciuser     = "svc_cloudinit"
  cipassword = var.pm_vm_cipassword
  sshkeys    = <<EOF
  ${var.ssh_key}
  EOF
}
