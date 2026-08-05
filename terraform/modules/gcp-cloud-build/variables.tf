variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "app_installation_id" {
  type = number
}

variable "github_pat_secret_id" {
  type        = string
  description = "Secret Manager secret ID for the GitHub PAT"
}

variable "repositories" {
  type = map(object({
    remote_uri = string
    branch     = optional(string, "^main$")
  }))
  default     = {}
  description = "Map of GitHub repositories to connect. Key = short name, value = remote URI + branch."
}