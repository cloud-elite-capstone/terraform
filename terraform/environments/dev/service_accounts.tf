data "google_project" "current" {
  project_id = var.project_id
}

data "google_compute_default_service_account" "default" {}

locals {
  service_accounts = {
    cloudbuild_service_agent = "service-${data.google_project.current.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
    cloudrun_service_agent   = "service-${data.google_project.current.number}@serverless-robot-prod.iam.gserviceaccount.com"

    compute_default = data.google_compute_default_service_account.default.email

    cloudbuild_runner = module.cloud_build.cloudbuild_sa_email
    terraform_runner  = var.gcp_service_account_email
  }

  service_account_members = {
    for name, email in local.service_accounts : name => "serviceAccount:${email}"
  }
}
