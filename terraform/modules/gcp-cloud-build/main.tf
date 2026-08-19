data "google_project" "current" {
  project_id = var.project_id
}

resource "google_service_account" "cloudbuild_sa" {
  account_id   = "cloudbuild-runner"
  display_name = "Cloud Build Runner Service Account"
}

resource "google_project_iam_member" "cloudbuild_builder" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

resource "google_secret_manager_secret_iam_member" "pat_accessor" {
  project   = var.project_id
  secret_id = var.github_pat_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

resource "google_service_account_iam_member" "cloudbuild_agent_user" {
  service_account_id = google_service_account.cloudbuild_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}

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

locals {
  triggers = {
    for trigger in flatten([
      for repo_key, repo in var.repositories : [
        for build_key, build in(
          length(repo.builds) > 0
          ? repo.builds
          : { default = {
            filename       = "cloudbuild.yaml"
            included_files = []
            ignored_files  = []
            substitutions  = {}
            disabled       = false
          } }
          ) : {
          name           = "${repo_key}-${build_key}"
          repository_key = repo_key
          branch         = repo.branch
          filename       = build.filename
          included_files = length(build.included_files) > 0 ? build.included_files : null
          ignored_files  = length(build.ignored_files) > 0 ? build.ignored_files : null
          substitutions  = length(build.substitutions) > 0 ? build.substitutions : null
          disabled       = build.disabled
        }
      ]
    ]) : trigger.name => trigger
  }
}

resource "google_cloudbuild_trigger" "push" {
  for_each = local.triggers

  name            = "push-${each.value.name}"
  location        = var.region
  service_account = google_service_account.cloudbuild_sa.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.repo[each.value.repository_key].id

    push {
      branch = each.value.branch
    }
  }

  included_files = each.value.included_files
  ignored_files  = each.value.ignored_files
  filename       = each.value.filename
  substitutions  = each.value.substitutions
  disabled       = each.value.disabled
}
