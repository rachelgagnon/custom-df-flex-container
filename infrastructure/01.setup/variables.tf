variable "bucket_prefix" {
  type        = string
  description = "The prefix for the bucket name"
}

variable "dataflow_worker_service_account_id" {
  type        = string
  description = "The Dataflow Worker Service Account ID"
}

variable "kms_key_ring_name" {
  type        = string
  description = "The name of the KMS key ring"
}

variable "project" {
  type        = string
  description = "The Google Cloud Platform (GCP) project within which resources are provisioned"
}

variable "resource_labels" {
  type = map(string)
  description = "Resource labels to apply to GCP resources"
}

variable "region" {
  type        = string
  description = "The Google Cloud Platform (GCP) region in which to provision resources"
}

variable "repository_id" {
  type        = string
  description = "The Artifact Registry repository ID for storing container images."
}

variable "secret_manager_secret_name" {
  type        = string
  description = "The name of the Secret Manager secret"
}
