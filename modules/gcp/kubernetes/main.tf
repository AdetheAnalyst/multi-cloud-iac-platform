# GCP GKE Cluster Module
terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}

variable "project_id"    { type = string }
variable "cluster_name"  { type = string }
variable "region"        { type = string }
variable "network"       { type = string }
variable "subnetwork"    { type = string }
variable "environment"   { type = string }

resource "google_container_cluster" "main" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  resource_labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

output "cluster_endpoint" { value = google_container_cluster.main.endpoint }
output "cluster_name"     { value = google_container_cluster.main.name }
