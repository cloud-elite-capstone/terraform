module "vps" {
  source = "../../modules/gcp-vm"

  instance_name = "build-server"
  machine_type  = "e2-micro"
}

resource "local_file" "vps_ip_file" {
  filename = "${path.module}/vps_ip.txt"
  content  = module.vps.internal_ip
}