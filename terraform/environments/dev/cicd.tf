module "artifact_registry" {
  source = "GoogleCloudPlatform/artifact-registry/google"

  project_id    = var.project_id
  location      = var.region
  format        = "DOCKER"
  repository_id = "dev-repo"
}

module "cloud_build" {
  source = "../../modules/gcp-cloud-build"

  region               = var.region
  project_id           = var.project_id
  app_installation_id  = 12345678   # todo: parameterize

  github_pat_secret_id = "github-pat" # todo: parameterize

  repositories = {
    server-a      = { remote_uri = "https://github.com/your-org/server-a.git" }
    server-b      = { remote_uri = "https://github.com/your-org/server-b.git" }
    react-frontend = { remote_uri = "https://github.com/your-org/react-frontend.git" }
  }
}