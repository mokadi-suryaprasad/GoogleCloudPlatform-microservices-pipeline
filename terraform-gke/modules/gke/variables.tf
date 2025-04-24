variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gke_cluster_name" {
  description = "Name of the GKE Cluster"
  type        = string
}

variable "gke_cluster_region" {
  description = "Region for GKE"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to use for the cluster"
  type        = string
}

variable "subnet_id" {
  description = "Subnetwork ID for the cluster"
  type        = string
}
