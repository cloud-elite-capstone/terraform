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
