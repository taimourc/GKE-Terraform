terraform {
  backend "gcs" {
    bucket = "terraform-gcp-backend"
    prefix = "terraform/state/gke-test"
  }
}
