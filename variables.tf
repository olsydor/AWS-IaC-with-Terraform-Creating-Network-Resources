variable "allowed_ip_range" {
  description = "List of IP CIDR ranges allowed for secure access"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the pre-created VPC"
  type        = string
  default     = ""
}

variable "public_subnet_id" {
  description = "ID of the pre-created public subnet"
  type        = string
  default     = ""
}

variable "private_subnet_id" {
  description = "ID of the pre-created private subnet"
  type        = string
  default     = ""
}

variable "public_instance_id" {
  description = "ID of the pre-created public EC2 instance"
  type        = string
  default     = ""
}

variable "private_instance_id" {
  description = "ID of the pre-created private EC2 instance"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region where resources are managed"
  type        = string
  default     = "us-east-1"
}

variable "project_id" {
  description = "Project identifier used for naming and tagging"
  type        = string
  default     = "cmtr-5bc36296"
}

variable "public_network_interface_id" {
  description = "Primary network interface ID of the public EC2 instance"
  type        = string
  default     = ""
}

variable "private_network_interface_id" {
  description = "Primary network interface ID of the private EC2 instance"
  type        = string
  default     = ""
}