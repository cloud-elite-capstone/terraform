resource "google_secret_manager_secret_iam_member" "github_pat_cloudbuild_reader" {
  secret_id = "projects/${var.project_id}/secrets/${var.github_pat_secret_id}"
  role      = "roles/secretmanager.secretAccessor"
  member    = local.service_account_members.cloudbuild_service_agent
}

resource "google_secret_manager_secret_iam_member" "gemini_api_key_cloudrun_accessor" {
  secret_id = "projects/${var.project_id}/secrets/${var.gemini_api_key_secret_id}"
  role      = "roles/secretmanager.secretAccessor"
  member    = local.service_account_members.compute_default
}

# Database password shared by all backend services, generated in database.tf.
resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

resource "google_secret_manager_secret_iam_member" "db_password_cloudrun_accessor" {
  secret_id = google_secret_manager_secret.db_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = local.service_account_members.compute_default
}
