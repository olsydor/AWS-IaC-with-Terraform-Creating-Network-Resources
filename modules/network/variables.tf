variable "project_id" {
  description = "Project identifier used in tags"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_names" {
  description = "Public subnet names"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for public subnets"
  type        = list(string)
}

variable "internet_gateway_name" {
  description = "Internet gateway name"
  type        = string
}

variable "route_table_name" {
  description = "Route table name"
  type        = string
}

variable "allowed_ip_range" {
  description = "List of IP address range for secure access"
  type        = list(string)
}
