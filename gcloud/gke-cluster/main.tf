terraform {
  required_providers {
    google = {
      version = ">4.25.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = "${var.region}-c"
}

resource "google_compute_network" "test" {
  name                    = "net-${var.resource_id_suffix}"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "test" {
  name          = "snet-${var.resource_id_suffix}"
  ip_cidr_range = "10.13.37.0/24"
  network       = google_compute_network.test.id
}

resource "google_container_cluster" "test" {
  name = "gke-${var.resource_id_suffix}"

  network    = google_compute_network.test.name
  subnetwork = google_compute_subnetwork.test.name

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_pool" {
  name       = "gke-nodepool-${var.resource_id_suffix}-primary"
  cluster    = google_container_cluster.test.id
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    disk_size_gb = 20

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}
