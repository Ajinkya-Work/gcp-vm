# main.tf
resource "google_compute_instance" "ubuntu_vm" {
  name         = var.vm_name                  # VM name
  machine_type = var.machine_type             # VM machine type
  zone         = var.zone                     # Zone for the VM

  # Define the boot disk (Ubuntu image version is a variable)
  boot_disk {
    initialize_params {
      image = var.image                       # VM image (Ubuntu version is dynamic)
    }
  }

  # Network configuration (default network and firewall rule to allow HTTP/HTTPS)
  network_interface {
    network = "default"                       # Use the default network
    access_config {
      # External IP configuration
    }
  }

  # Optionally, you can add tags, metadata, etc.
  tags = var.tags                             # Use tags variable

  metadata = {
    startup-script = var.startup_script      # Custom startup script
  }

  # Enable SSH access
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello, Ubuntu!'"
    ]
  }
}

