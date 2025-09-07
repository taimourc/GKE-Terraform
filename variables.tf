variable "project_id" {
  type        = string
  description = "GCP project ID (not number).  # <--- YOU: set in terraform.tfvars or TF_VAR_project_id"
}

variable "project_number" {
  type        = string
  description = "GCP project number (for reference)."
  default     = "449091360567"
}

variable "region" {
  type        = string
  description = "GCP region for all regional resources"
  default     = "us-central1"
}

variable "network_name" {
  type        = string
  default     = "vpc-test"
  description = "Name for the VPC network"
}

variable "subnet1_name" {
  type        = string
  default     = "subnet1-test"
}

variable "subnet2_name" {
  type        = string
  default     = "subnet2-test"
}

variable "subnet1_cidr" {
  type        = string
  default     = "10.10.0.0/20"
  description = "Primary CIDR for subnet1 (used by the cluster)"
}

variable "subnet2_cidr" {
  type        = string
  default     = "10.20.0.0/20"
}

variable "pods_cidr" {
  type        = string
  default     = "10.0.0.0/14"
}

variable "services_cidr" {
  type        = string
  default     = "172.16.0.0/20"
}

variable "cluster_name" {
  type        = string
  default     = "gke-cluster-test"
}

variable "nodepool_name" {
  type        = string
  default     = "gke-nodepool-test"
}

variable "node_count" {
  type        = number
  default     = 2
}

variable "node_machine_type" {
  type        = string
  default     = "e2-micro"
}
