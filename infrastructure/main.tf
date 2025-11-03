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
    startup-script = file(var.startup_script_path)  # Read script content from path
  }
}

# Firewall rule to allow incoming traffic based on the provided ports array
resource "google_compute_firewall" "allow_ports" {
  name    = "allow-custom-ports"
  network = "default"  # Apply firewall rule to the default network

  dynamic "allow" {
    for_each = var.allowed_ports
    content {
      protocol = "tcp"
      ports    = [allow.value]
    }
  }

  source_ranges = ["0.0.0.0/0"]  # Allow access from anywhere

  target_tags = var.tags  # Apply rule only to instances with these tags
}
