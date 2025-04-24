locals {
  project_id = "silken-oxygen-454215-v6"
  region     = "us-central1"
  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

resource "google_project_service" "api" {
  for_each = toset(local.apis)
  service  = each.key
  disable_on_destroy = false
}

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

module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = var.vpc_name
  region               = local.region
  public_subnet        = var.public_subnet
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet       = var.private_subnet
  private_subnet_cidrs = var.private_subnet_cidrs
}


module "gke" {
  source              = "./modules/gke"
  project_id          = local.project_id
  gke_cluster_name    = var.cluster_name
  gke_cluster_region  = local.region
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.private_subnet_id
}


