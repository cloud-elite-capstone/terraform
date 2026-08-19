project_id                = "your-gcp-project-id"
region                    = "asia-southeast1"
network_name              = "cloud-elite-prod-vpc"
gcp_service_account_email = "your-service-account@your-project.iam.gserviceaccount.com"
frontend_image            = "gcr.io/your-project/frontend:latest"
server_images = {
  server1 = "gcr.io/your-project/server1:latest"
  server2 = "gcr.io/your-project/server2:latest"
}

# app_installation_id  = 12345678
# github_pat_secret_id = "github-pat"

artifact_registry_repository_id = "prod-repo"
# github_repositories = {
#   server-a = {
#     remote_uri = "https://github.com/your-org/server-a.git"
#   }
#   server-b = {
#     remote_uri = "https://github.com/your-org/server-b.git"
#   }
#   react-frontend = {
#     remote_uri = "https://github.com/your-org/react-frontend.git"
#   }
# }
