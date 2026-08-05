module "artifact_registry" {
  source = "GoogleCloudPlatform/artifact-registry/google"

  project_id    = var.project_id
  location      = var.region
  format        = "DOCKER"
  repository_id = var.artifact_registry_repository_id
}

module "cloud_build" {
  source = "../../modules/gcp-cloud-build"

  region              = var.region
  project_id          = var.project_id
  app_installation_id = var.app_installation_id

  github_pat_secret_id = var.github_pat_secret_id

  repositories = var.github_repositories
}