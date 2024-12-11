// Query the Google Project context
data "google_project" "default" {}

// Query the KMS keyring.
data "google_kms_key_ring" "default" {
  name     = var.kms_keyring_id
  location = var.region
}

// Query the KMS key.
data "google_kms_crypto_key" "default" {
  key_ring = data.google_kms_key_ring.default.id
  name     = var.kms_key_id
}

// Query the Dataflow Worker Service Account
data "google_service_account" "dataflow_worker" {
  account_id = var.dataflow_worker_service_account_id
}

// Query the Google Cloud Network
data "google_compute_network" "default" {
  name = var.network
}

// Query the Google Cloud Subnetwork
data "google_compute_subnetwork" "default" {
  name   = var.subnetwork
  region = var.region
}
