output "instance_id" {
  value       = google_compute_instance.vm.instance_id
  description = "The server-assigned unique identifier of the VM"
}

output "name" {
  value       = google_compute_instance.vm.name
  description = "The name of the VM"
}

output "internal_ip" {
  value       = google_compute_instance.vm.network_interface[0].network_ip
  description = "The internal IP address of the VM"
}

output "public_ip" {
  value       = var.assign_public_ip ? google_compute_instance.vm.network_interface[0].access_config[0].nat_ip : null
  description = "The public IP address of the VM, if one is assigned"
}

output "self_link" {
  value       = google_compute_instance.vm.self_link
  description = "The self link of the VM"
}
