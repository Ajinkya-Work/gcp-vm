# variables.tf

# Project ID
variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

# Region and Zone
variable "region" {
  description = "The region to deploy the VM in."
  default     = "asia-south1"  # Default region as AP-South-1
  type        = string
}

variable "zone" {
  description = "The zone to deploy the VM in."
  default     = "asia-south1-a"  # Default zone for AP-South-1
  type        = string
}

# VM Name
variable "vm_name" {
  description = "The name of the VM instance."
  default     = "ubuntu-vm"  # Default name of the VM
  type        = string
}

# Machine Type
variable "machine_type" {
  description = "The machine type for the VM instance."
  default     = "n2-standard-4"  # Default machine type (n2-standard-4)
  type        = string
}

# Image to use for the boot disk
variable "image" {
  description = "The image to use for the boot disk (e.g. Ubuntu version)."
  default     = "ubuntu-2404-lts"  # Default image (Ubuntu 24.04 LTS)
  type        = string
}

# Tags for the VM
variable "tags" {
  description = "Tags for the VM instance."
  default     = ["http-server", "https-server"]  # Tags for HTTP/HTTPS traffic
  type        = list(string)
}

# Startup script for the VM
variable "startup_script" {
  description = "Startup script to run on VM initialization."
  default     = "#!/bin/bash\nsudo apt-get update && sudo apt-get upgrade -y"
  type        = string
}
