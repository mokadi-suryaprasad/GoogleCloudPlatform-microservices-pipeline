resource "google_container_cluster" "gke" {
  name                     = var.gke_cluster_name
  location                 = var.gke_cluster_region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  networking_mode          = "VPC_NATIVE"

  deletion_protection = false

  # Optional, if you want multi-zonal cluster
  # node_locations = ["us-central1-b"]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pods"
    services_secondary_range_name = "k8s-services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "192.168.0.0/28"
  }

  # Jenkins use case
  # master_authorized_networks_config {
  #   cidr_blocks {
  #     cidr_block   = "10.0.0.0/18"
  #     display_name = "private-subnet"
  #   }
  # }
}

resource "google_service_account" "gke" {
  account_id = "demo-gke"
}

resource "google_project_iam_member" "gke_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_metrics" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_container_node_pool" "general" {
  name    = "general"
  cluster = google_container_cluster.gke.id

  autoscaling {
    total_min_node_count = 1
    total_max_node_count = 5
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    labels = {
      role = "general"
    }

    # taint {
    #   key    = "instance_type"
    #   value  = "spot"
    #   effect = "NO_SCHEDULE"
    # }

    service_account = google_service_account.gke.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Required for Terraform to connect to your GKE cluster
data "google_client_config" "default" {}

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.gke.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [helm_release.nginx_ingress]
}