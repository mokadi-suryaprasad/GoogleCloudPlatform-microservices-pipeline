# Define output for VPC ID
output "vpc_id" {
  value = google_compute_network.vpc.id
}

# Define output for private subnet ID
output "private_subnet_id" {
  value = google_compute_subnetwork.private.id
}