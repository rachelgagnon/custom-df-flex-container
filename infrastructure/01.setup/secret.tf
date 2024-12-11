// Provision Secret Manager secret to store the Oracle MySQL connection string.
resource "google_secret_manager_secret" "connection_string" {
  depends_on = [google_project_service.required_services]
  secret_id = var.secret_manager_secret_name
  labels    = var.resource_labels
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

// Allow access to the Secret Manager secret connection string by the Dataflow worker service account.
resource "google_secret_manager_secret_iam_member" "connection_string" {
  member    = "serviceAccount:${google_service_account.dataflow_worker.email}"
  role      = "roles/secretmanager.secretAccessor"
  secret_id = google_secret_manager_secret.connection_string.id
}
