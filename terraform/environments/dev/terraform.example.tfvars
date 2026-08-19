project_id                = "your-gcp-project-id"
region                    = "asia-southeast1"
network_name              = "cloud-elite-dev-vpc"
gcp_service_account_email = "your-service-account@your-project.iam.gserviceaccount.com"
frontend_image            = "gcr.io/your-project/frontend:latest"
server_images = {
  server1 = "gcr.io/your-project/server1:latest"
  server2 = "gcr.io/your-project/server2:latest"
}

app_installation_id  = 12345678
github_pat_secret_id = "github-pat"

artifact_registry_repository_id = "dev-repo"
github_repositories = {
  monorepo = {
    remote_uri = "https://github.com/your-org/monorepo.git"
    branch     = "^main$"

    builds = {
      server-a = {
        filename       = "server-a/cloudbuild.yaml"
        included_files = ["server-a/**"]
      }
      server-b = {
        filename       = "server-b/cloudbuild.yaml"
        included_files = ["server-b/**"]
      }
      react-frontend = {
        filename       = "frontend/cloudbuild.yaml"
        included_files = ["frontend/**"]
      }
    }
  }
}
