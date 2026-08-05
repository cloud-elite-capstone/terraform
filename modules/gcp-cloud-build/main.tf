resource "google_cloudbuildv2_connection" "github" {
  name     = "github"
  location = var.region

  github_config {
    app_installation_id = var.app_installation_id

    authorizer_credential {
      oauth_token_secret_version = "projects/${var.project_id}/secrets/${var.github_pat_secret_id}/versions/1"
    }
  }
}

resource "google_cloudbuildv2_repository" "repo" {
  for_each = var.repositories

  name              = each.key
  parent_connection = google_cloudbuildv2_connection.github.id
  location          = var.region
  remote_uri        = each.value.remote_uri
}

resource "google_cloudbuildv2_trigger" "push" {
  for_each = var.repositories

  name       = "push-${each.key}"
  location   = var.region
  repository = google_cloudbuildv2_repository.repo[each.key].id

  repository_event_config {
    push {
      branch = each.value.branch
    }
  }
}