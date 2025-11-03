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

# Path to the startup script file (use file() function in main.tf to read it)
variable "startup_script_path" {
  description = "The path to the startup script file."
  type        = string
  default     = "./startup-script.sh"  # Default path to the startup script
}

# Allowed ports array for firewall rules (e.g., 80 for HTTP, 443 for HTTPS, etc.)
variable "allowed_ports" {
  description = "Array of ports to be allowed through the firewall."
  type        = list(number)
  default     = [22, 80, 443]  # Default ports: SSH, HTTP, and HTTPS
}
