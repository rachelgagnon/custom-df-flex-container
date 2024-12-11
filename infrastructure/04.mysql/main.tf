terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.14"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

// Provision Bitnami MySql helm chart.
// TODO: consider changing this to
// https://github.com/oracle/docker-images/tree/main/OracleDatabase/SingleInstance/helm-charts/oracle-db
resource "helm_release" "mysql" {
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  chart            = "mysql"
  name             = "mysql"
  namespace        = "mysql"
  version          = "12.1.0"
  create_namespace = true
  wait             = false
}
