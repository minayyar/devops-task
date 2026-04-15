variable "project_id" {
  description = "GCP Project ID"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "my_ip" {
  description = "Your public IP for SSH access (x.x.x.x/32)"
}

variable "ssh_public_key" {
  description = "SSH public key from GitHub Secrets"
}
