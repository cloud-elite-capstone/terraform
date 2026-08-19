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

variable "gemini_api_key_secret_id" {
  type        = string
  description = "Secret Manager secret ID holding the Gemini API key"
  default     = "gemini-api-key"
}

variable "artifact_registry_repository_id" {
  type = string
}

variable "github_repositories" {
  type = map(object({
    remote_uri = string
    branch     = optional(string, "^main$")
    builds = optional(map(object({
      filename       = optional(string, "cloudbuild.yaml")
      included_files = optional(list(string), [])
      ignored_files  = optional(list(string), [])
      substitutions  = optional(map(string), {})
      disabled       = optional(bool, false)
    })), {})
  }))
}
