resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "google_storage_bucket" "default" {
  location                    = var.region
  name                        = "${var.bucket_prefix}-${random_string.suffix.result}"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  labels                      = var.resource_labels
}

resource "google_storage_bucket_iam_member" "dataflow_worker" {
  depends_on = [google_project_service.required_services]
  bucket = google_storage_bucket.default.name
  member = "serviceAccount:${google_service_account.dataflow_worker.email}"
  role   = "roles/storage.objectAdmin"
}
