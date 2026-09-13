module "artifact_registry" {
  source = "GoogleCloudPlatform/artifact-registry/google"

  project_id    = var.project_id
  location      = var.region
  format        = "DOCKER"
  repository_id = var.artifact_registry_repository_id
}

# Allow Cloud Build to push images and Cloud Run to pull images from Artifact Registry.
resource "google_artifact_registry_repository_iam_member" "cloudbuild_writer" {
  project    = var.project_id
  location   = var.region
  repository = var.artifact_registry_repository_id
  role       = "roles/artifactregistry.writer"
  member     = local.service_account_members.cloudbuild_service_agent

  depends_on = [module.artifact_registry]
}

resource "google_artifact_registry_repository_iam_member" "cloudrun_reader" {
  project    = var.project_id
  location   = var.region
  repository = var.artifact_registry_repository_id
  role       = "roles/artifactregistry.reader"
  member     = local.service_account_members.cloudrun_service_agent

  depends_on = [module.artifact_registry]
}

module "cloud_build" {
  source = "../../modules/gcp-cloud-build"

  region              = var.region
  project_id          = var.project_id
  app_installation_id = var.app_installation_id

  github_pat_secret_id = var.github_pat_secret_id

  repositories = var.github_repositories
}

# Allow Cloud Build to deploy new Cloud Run revisions.
resource "google_project_iam_member" "cloudbuild_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = local.service_account_members.cloudbuild_runner
}

resource "google_service_account_iam_member" "cloudbuild_run_sa_user" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${local.service_accounts.compute_default}"
  role               = "roles/iam.serviceAccountUser"
  member             = local.service_account_members.cloudbuild_runner
}
