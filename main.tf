terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # -------------------------
  # Remote State (GCS Backend)
  # -------------------------
  backend "gcs" {
    bucket = "performos-terraform"
    prefix = "devops-task/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# -------------------------
# VPC
# -------------------------
resource "google_compute_network" "vpc" {
  name                    = "devops-task-vpc"
  auto_create_subnetworks = false
}

# -------------------------
# Subnet
# -------------------------
resource "google_compute_subnetwork" "subnet" {
  name          = "devops-task-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# -------------------------
# Firewall - HTTP
# -------------------------
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# -------------------------
# Firewall - HTTPS
# -------------------------
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# -------------------------
# Firewall - SSH (restricted)
# -------------------------
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.my_ip]
}

# -------------------------
# VM Instance
# -------------------------
resource "google_compute_instance" "vm" {
  name         = "devops-task-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["devops-task"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {}
  }

  # SSH key from GitHub Secrets
  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  metadata_startup_script = file("startup.sh")
}

# -------------------------
# OUTPUT
# -------------------------
output "vm_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
