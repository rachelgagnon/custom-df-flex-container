terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.34"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}

// Setup Google Cloud provider
provider "google" {
  project = var.project
}