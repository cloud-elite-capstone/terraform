module "vpc" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = var.network_name

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    }
  ]
}
