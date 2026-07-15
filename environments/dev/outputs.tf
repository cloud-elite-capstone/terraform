output "dev_vps_ip" {
  value       = module.vps.internal_ip
  description = "The IP address of our dev server"
}