module "spring_boot_servers" {
  source = "GoogleCloudPlatform/cloud-run/google"

  for_each = {
    "server1" = {
      image = "<placeholder>"
    },
    "server2" = {
      image = "<placeholder>"
    }
  }

  location   = var.region
  project_id = var.project_id

  image        = each.value.image
  service_name = each.key
}