variable "bigquery_dataset_id" {
  type        = string
  description = "The BigQuery dataset ID into which we load data"
}

variable "dataflow_worker_service_account_id" {
  type        = string
  description = "The Dataflow Worker Service Account ID"
}

variable "kms_keyring_id" {
  type        = string
  description = "The KMS keyring ID"
}

variable "kms_key_id" {
  type        = string
  description = "The KMS key ID"
}

variable "kubernetes_engine_cluster_name" {
  type        = string
  description = "The name of the Google Kubernetes Engine cluster"
}

variable "network" {
  type        = string
  description = "The Google Cloud custom network"
}

variable "project" {
  type        = string
  description = "The Google Cloud Platform (GCP) project within which resources are provisioned"
}

variable "region" {
  type        = string
  description = "The Google Cloud Platform (GCP) region in which to provision resources"
}

variable "resource_labels" {
  type = map(string)
  description = "Resource labels to apply to GCP resources"
}

variable "subnetwork" {
  type        = string
  description = "The Google Cloud custom subnetwork"
}