# output "devpod_vm_public_ip" {
#   value       = module.devpod_vm.public_ip
#   description = "Public IP address of the DevPod VM"
# }

# output "devpod_vm_ssh_command" {
#   value       = "ssh ${var.devpod_ssh_user}@${output.devpod_vm_public_ip.value}"
#   description = "SSH command to connect to the DevPod VM"
# }

# resource "local_file" "devpod_ssh_command" {
#   content  = output.devpod_vm_ssh_command.value
#   filename = "${path.module}/devpod_ssh_command.txt"
# }
