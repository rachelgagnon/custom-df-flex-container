bucket_prefix                      = "example"
dataflow_worker_service_account_id = "dataflow-worker"
kms_key_ring_name                  = "data-pipeline"
region                             = "us-central1"
repository_id                      = "templates"
resource_labels = {
  workload = "data-pipelines"
}
secret_manager_secret_name = "jdbc-connection-string"
