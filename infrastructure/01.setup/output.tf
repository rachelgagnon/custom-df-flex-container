output "service_account" {
  value = google_service_account.dataflow_worker
}

output "secret_manager_secret" {
  value = google_secret_manager_secret.connection_string
}

output "kms_key" {
  value = google_kms_crypto_key.default
}

output "bucket" {
  value = google_storage_bucket.default
}
