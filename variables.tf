variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created"
  default     = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "cmtr-5bc36296-01-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.10.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "VPC CIDR block must be a valid IPv4 CIDR notation."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones where public subnets will be created"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

variable "public_subnet_names" {
  type        = list(string)
  description = "Names for the public subnets"
  default = [
    "cmtr-5bc36296-01-subnet-public-a",
    "cmtr-5bc36296-01-subnet-public-b",
    "cmtr-5bc36296-01-subnet-public-c"
  ]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default = [
    "10.10.1.0/24",
    "10.10.3.0/24",
    "10.10.5.0/24"
  ]

  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All public subnet CIDR blocks must be valid IPv4 CIDR notation."
  }
}

variable "internet_gateway_name" {
  type        = string
  description = "Name of the Internet Gateway"
  default     = "cmtr-5bc36296-01-igw"
}

variable "route_table_name" {
  type        = string
  description = "Name of the route table"
  default     = "cmtr-5bc36296-01-rt"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS support in the VPC"
  default     = true
}

variable "enable_public_ip_on_launch" {
  type        = bool
  description = "Enable automatic public IP assignment for instances launched in public subnets"
  default     = true
}
variable "ssh_key" {
  type        = string
  description = "Provides custom public SSH key."
  sensitive   = true
}