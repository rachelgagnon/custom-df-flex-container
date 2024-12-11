terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.34"
    }
  }
}

// Setup Google Cloud provider
provider "google" {
  project = var.project
}
