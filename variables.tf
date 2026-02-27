variable "allowed_ip_range" {
  description = "List of IP CIDR ranges allowed for secure access"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the pre-created VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the pre-created public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the pre-created private subnet"
  type        = string
}

variable "public_instance_id" {
  description = "ID of the pre-created public EC2 instance"
  type        = string
}

variable "private_instance_id" {
  description = "ID of the pre-created private EC2 instance"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources are managed"
  type        = string
}

variable "project_id" {
  description = "Project identifier used for naming and tagging"
  type        = string
}