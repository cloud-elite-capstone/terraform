data "google_compute_default_service_account" "default" {}

locals {
  default_invoker = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}",
  ]

  # Services with no outbound calls to other services
  leaf_services = {
    for name, image in var.server_images : name => image
    if name != "agent-service" && name != "agent-orchestrator-service"
  }

  service_ports = {
    "user-service"               = 8081
    "shop-service"               = 8082
    "product-service"            = 8083
    "order-service"              = 8084
    "agent-service"              = 8085
    "agent-orchestrator-service" = 8086
  }
}

module "backend_servers" {
  source = "GoogleCloudPlatform/cloud-run/google"

  for_each = local.leaf_services

  location   = var.region
  project_id = var.project_id

  image        = each.value
  service_name = each.key

  members = local.default_invoker
  ports   = { name = "http1", port = local.service_ports[each.key] }
}

module "agent_service" {
  source = "GoogleCloudPlatform/cloud-run/google"

  location   = var.region
  project_id = var.project_id

  image        = var.server_images["agent-service"]
  service_name = "agent-service"

  members = local.default_invoker
  ports   = { name = "http1", port = local.service_ports["agent-service"] }

  timeout_seconds = 600

  env_vars = [
    { name = "PRODUCT_SERVICE_URL", value = module.backend_servers["product-service"].service_url },
  ]

  env_secret_vars = [
    {
      name = "GEMINI_API_KEY"
      value_from = [{
        secret_key_ref = {
          name = var.gemini_api_key_secret_id
          key  = "latest"
        }
      }]
    },
  ]
}

module "orchestrator_service" {
  source = "GoogleCloudPlatform/cloud-run/google"

  location   = var.region
  project_id = var.project_id

  image        = var.server_images["agent-orchestrator-service"]
  service_name = "agent-orchestrator-service"

  members = local.default_invoker
  ports   = { name = "http1", port = local.service_ports["agent-orchestrator-service"] }

  env_vars = [
    { name = "PRODUCT_SERVICE_URL", value = module.backend_servers["product-service"].service_url },
    { name = "AGENT_SERVICE_URL", value = module.agent_service.service_url },
  ]
}
