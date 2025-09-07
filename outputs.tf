##############################
# outputs.tf
##############################

output "cluster_endpoint" {
  description = "GKE control plane endpoint IP/DNS"
  value       = google_container_cluster.gke.endpoint
}

output "cluster_name" {
  value = google_container_cluster.gke.name
}

output "region" {
  value = var.region
}
