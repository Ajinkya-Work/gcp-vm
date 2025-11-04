# provider.tf
provider "google" {
  credentials = file("${path.module}/service-account.json") # reads file content
  project = var.project_id  # The GCP project ID
  region  = var.region      # The region to deploy resources in
  zone    = var.zone        # The zone to deploy the VM in
}
