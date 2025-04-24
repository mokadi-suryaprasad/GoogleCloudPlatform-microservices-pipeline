provider "google" {
  project = local.project_id
  region  = local.region
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  backend "gcs" {
    bucket = "gcp-devops-by-surya"
    prefix = "terraform/state"
  }
}