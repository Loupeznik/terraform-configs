terraform {
  required_providers {
    google = {
      version = "~> 4.0.0"
    }
  }
}

variable "project" {
  type = string
  sensitive = true
  description = "Project name"
}

provider "google" {
  project = var.project
  region  = "us-east1"
  zone    = "us-east1-c"
}

resource "google_compute_network" "test" {
  name                    = "net-dz-test-01"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "test" {
  name          = "snet-dz-test-01"
  ip_cidr_range = "10.13.37.0/24"
  network       = google_compute_network.test.id
}

resource "google_compute_firewall" "test" {
  name    = "fw-dz-test-01"
  network = google_compute_network.test.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "test" {
  name         = "gcp-centos-0"
  machine_type = "e2-micro"
  tags         = ["test"]

  metadata = {
    ssh-keys = "master:${file("~/.ssh/tf_tests_id_rsa.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-9"
    }
  }

  metadata_startup_script = "sudo yum update -y && sudo yum install epel-release -y && sudo yum install nginx -y && sudo systemctl start nginx"

  network_interface {
    subnetwork = google_compute_subnetwork.test.id

    access_config {
      network_tier = "STANDARD"
    }
  }
}

output "public_ip" {
  value = google_compute_instance.test.network_interface[0].access_config[0].nat_ip
}
