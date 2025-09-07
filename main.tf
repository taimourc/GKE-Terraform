resource "google_project_service" "apis" {
  for_each           = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
  ])
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  depends_on              = [google_project_service.apis]
}

# Subnet 1 
resource "google_compute_subnetwork" "subnet1" {
  name                     = var.subnet1_name
  ip_cidr_range            = var.subnet1_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods-${var.subnet1_name}"
    ip_cidr_range = var.pods_cidr
  }
  secondary_ip_range {
    range_name    = "services-${var.subnet1_name}"
    ip_cidr_range = var.services_cidr
  }
}

# Subnet 2
resource "google_compute_subnetwork" "subnet2" {
  name                     = var.subnet2_name
  ip_cidr_range            = var.subnet2_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Service account for nodes
resource "google_service_account" "node_sa" {
  account_id   = "gke-node-sa-test"
  display_name = "GKE Node Service Account (test)"
}

resource "google_project_iam_member" "node_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.node_sa.email}"
}
resource "google_project_iam_member" "node_sa_monitoring_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.node_sa.email}"
}
resource "google_project_iam_member" "node_sa_monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.node_sa.email}"
}

# GKE cluster 
resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet1.name

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnet1.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.subnet1.secondary_ip_range[1].range_name
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  enable_shielded_nodes = true

  depends_on = [
    google_compute_subnetwork.subnet1,
    google_project_service.apis
  ]
}

# Node pool 
resource "google_container_node_pool" "primary" {
  name       = var.nodepool_name
  cluster    = google_container_cluster.gke.name
  location   = var.region
  node_count = var.node_count

  node_config {
    machine_type    = var.node_machine_type
    image_type      = "COS_CONTAINERD"
    service_account = google_service_account.node_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    labels = {
      nodepool = var.nodepool_name
    }
    tags = ["gke-node-test"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
