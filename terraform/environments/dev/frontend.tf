module "react_frontend" {
  source = "GoogleCloudPlatform/cloud-run/google"

  location   = var.region
  project_id = var.project_id

  image        = var.frontend_image
  service_name = "react-frontend"

  env_vars = [
    { name = "ORCHESTRATOR_SERVICE_URL", value = module.orchestrator_service.service_url },
    { name = "AGENT_SERVICE_URL", value = module.agent_service.service_url },
    { name = "PRODUCT_SERVICE_URL", value = module.backend_servers["product-service"].service_url },
    { name = "ORDER_SERVICE_URL", value = module.backend_servers["order-service"].service_url },
    { name = "SHOP_SERVICE_URL", value = module.backend_servers["shop-service"].service_url },
    { name = "USER_SERVICE_URL", value = module.backend_servers["user-service"].service_url },
  ]
}

module "react_frontend_iam" {
  source = "terraform-google-modules/iam/google//modules/cloud_run_services_iam"

  cloud_run_services = [module.react_frontend.service_name]

  bindings = {
    "roles/run.invoker" = [
      "allUsers"
    ]
  }
}
