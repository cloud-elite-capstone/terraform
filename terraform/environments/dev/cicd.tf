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
  member     = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"

  depends_on = [module.artifact_registry]
}

resource "google_artifact_registry_repository_iam_member" "cloudrun_reader" {
  project    = var.project_id
  location   = var.region
  repository = var.artifact_registry_repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:service-${data.google_project.current.number}@serverless-robot-prod.iam.gserviceaccount.com"

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
