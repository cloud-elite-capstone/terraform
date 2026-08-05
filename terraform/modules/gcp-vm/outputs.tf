output "internal_ip" {
  value       = google_compute_instance.vm.network_interface[0].network_ip
  type        = string
  description = "The internal IP address of the VM"
}