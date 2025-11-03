# provider.tf
provider "google" {
  project = var.project_id  # The GCP project ID
  region  = var.region      # The region to deploy resources in
  zone    = var.zone        # The zone to deploy the VM in
}
