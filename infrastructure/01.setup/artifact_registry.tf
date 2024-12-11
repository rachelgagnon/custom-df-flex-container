// Provision Artifact Registry repository to store Dataflow Template container images.
resource "google_artifact_registry_repository" "templates" {
  depends_on = [google_project_service.required_services]
  format        = "Docker"
  repository_id = var.repository_id
  location      = var.region
  labels        = var.resource_labels
}

// Allow Dataflow worker access to Artifact Registry repository.
resource "google_artifact_registry_repository_iam_member" "templates" {
  member     = "serviceAccount:${google_service_account.dataflow_worker.email}"
  repository = google_artifact_registry_repository.templates.id
  role       = "roles/artifactregistry.reader"
}
