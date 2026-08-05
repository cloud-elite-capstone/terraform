variable "project_id" {
  type = string
}
variable "gcp_service_account_email" {
  type        = string
  description = "Service account email to impersonate"
}

variable "region" {
  type = string
}

variable "network_name" {
  type = string
}

variable "frontend_image" {
  type = string
}

variable "server_images" {
  type = map(string)
}

variable "app_installation_id" {
  type = number
}

variable "github_pat_secret_id" {
  type = string
}

variable "artifact_registry_repository_id" {
  type = string
}

variable "github_repositories" {
  type = map(object({ remote_uri = string }))
}
