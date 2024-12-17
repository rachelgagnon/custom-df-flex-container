resource "google_kms_key_ring" "default" {
  depends_on = [google_project_service.required_services]
  location = var.region
  name     = var.kms_key_ring_name
}

// Allow the service account access to KMS key.
// See https://cloud.google.com/dataflow/docs/guides/customer-managed-encryption-keys#grant
resource "google_project_iam_member" "kms" {
  depends_on = [google_project_service.required_services]
  for_each = toset([
    "serviceAccount:service-${data.google_project.project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
    "serviceAccount:bq-${data.google_project.project.number}@bigquery-encryption.iam.gserviceaccount.com",
    "serviceAccount:${google_service_account.dataflow_worker.email}",
  ])
  member  = each.key
  project = var.project
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}

resource "google_kms_crypto_key" "default" {
  key_ring = google_kms_key_ring.default.id
  name     = var.kms_key_ring_name
  labels   = var.resource_labels
}
