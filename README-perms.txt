Required IAM for the identity running Terraform (CI service account or your user)
================================================================================
Project number: 449091360567  (for reference only)

On the PROJECT (to create network, cluster, node SA & bindings, and enable APIs):
  - roles/container.admin
  - roles/compute.networkAdmin
  - roles/iam.serviceAccountAdmin
  - roles/resourcemanager.projectIamAdmin
  - roles/serviceusage.serviceUsageAdmin

On the STATE BUCKET (GCS) used by the Terraform backend:
  - roles/storage.objectAdmin  (bucket-level)

Additional note for node service account usage in GKE:
  - The human/CI principal creating the cluster must have roles/iam.serviceAccountUser on the
    node service account (gke-node-sa-test@<project>.iam.gserviceaccount.com) to assign it to nodes.

Backend bucket (already set in backend.tf):
  gs://terraform-gcp-backend  (region: us-central1; enable versioning)
