data "google_project" "current" {
  project_id = var.project_id
}

resource "google_secret_manager_secret_iam_member" "github_pat_cloudbuild_reader" {
  secret_id = "projects/${var.project_id}/secrets/${var.github_pat_secret_id}"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}

resource "google_secret_manager_secret_iam_member" "gemini_api_key_cloudrun_accessor" {
  secret_id = "projects/${var.project_id}/secrets/${var.gemini_api_key_secret_id}"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}
