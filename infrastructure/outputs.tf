# outputs.tf
output "external_ip" {
  value       = google_compute_instance.ubuntu_vm.network_interface[0].access_config[0].nat_ip
  description = "The external IP address of the created VM."
}
