resource "google_container_cluster" "default" {
  name                = var.kubernetes_engine_cluster_name
  deletion_protection = false
  location            = var.region
  enable_autopilot    = true
  network             = data.google_compute_network.default.id
  subnetwork          = data.google_compute_subnetwork.default.id
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
  }
  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = data.google_service_account.dataflow_worker.email
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }
  resource_labels = var.resource_labels
}
