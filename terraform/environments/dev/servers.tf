module "spring_boot_servers" {
  source = "GoogleCloudPlatform/cloud-run/google"

  for_each = var.server_images

  location   = var.region
  project_id = var.project_id

  image        = each.value.image
  service_name = each.key
}