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
    builds = optional(map(object({
      filename       = optional(string, "cloudbuild.yaml")
      included_files = optional(list(string), [])
      ignored_files  = optional(list(string), [])
      substitutions  = optional(map(string), {})
      disabled       = optional(bool, false)
    })), {})
  }))
  default     = {}
  description = "Map of GitHub repositories to connect. Key = short name. Each repository can define one or more build triggers via `builds` (monorepo support)."
}
