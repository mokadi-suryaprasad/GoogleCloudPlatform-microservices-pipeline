variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "public_subnet" {
  description = "Name of the public subnet"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR range for the public subnet"
  type        = string
}

variable "private_subnet" {
  description = "Name of the private subnet"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDR range for the private subnet"
  type        = string
}
