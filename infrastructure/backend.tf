terraform {
  backend "gcs" {
    bucket = "tf-backend-bucket-lv"
    prefix = "terraform/state"
  }
}