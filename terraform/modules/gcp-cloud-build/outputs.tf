output "connection_id" {
  value       = google_cloudbuildv2_connection.github.id
  description = "The fully-qualified ID of the Cloud Build v2 connection"
}

output "connection_name" {
  value       = google_cloudbuildv2_connection.github.name
  description = "The name of the Cloud Build v2 connection"
}

output "repository_ids" {
  value = {
    for k, v in google_cloudbuildv2_repository.repo : k => v.id
  }
  description = "Map of repository short names to their fully-qualified IDs"
}