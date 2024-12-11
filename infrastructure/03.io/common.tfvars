bigquery_dataset_id                = "example"
dataflow_worker_service_account_id = "dataflow-worker"
kms_key_id                         = "data-pipeline"
kms_keyring_id                     = "data-pipeline"
kubernetes_engine_cluster_name     = "data-pipeline"
network                            = "data-processing"
region                             = "us-central1"
resource_labels = {
  workload = "data-pipelines"
}
subnetwork = "data-processing"
