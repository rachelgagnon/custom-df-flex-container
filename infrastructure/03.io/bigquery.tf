// Provision BigQuery dataset for use as sink
resource "google_bigquery_dataset" "sink" {
  dataset_id = var.bigquery_dataset_id
  default_encryption_configuration {
    kms_key_name = data.google_kms_crypto_key.default.id
  }
  location = var.region
  labels   = var.resource_labels
}

resource "google_bigquery_dataset_iam_member" "sink" {
  dataset_id = google_bigquery_dataset.sink.dataset_id
  member     = "serviceAccount:${data.google_service_account.dataflow_worker.email}"
  role       = "roles/bigquery.dataEditor"
}
