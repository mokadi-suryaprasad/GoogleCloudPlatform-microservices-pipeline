variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "public_subnet" {
  description = "Name of the public subnet"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet" {
  description = "Name of the private subnet"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}
