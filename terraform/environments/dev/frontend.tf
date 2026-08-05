module "react_frontend" {
  source = "GoogleCloudPlatform/cloud-run/google"

  location   = var.region
  project_id = var.project_id

  image        = var.frontend_image
  service_name = "react-frontend"
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