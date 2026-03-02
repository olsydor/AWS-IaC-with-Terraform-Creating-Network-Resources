variable "project_id" {
  description = "Project identifier used in tags"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for creating security groups"
  type        = string
}

variable "allowed_ip_range" {
  description = "List of IP ranges allowed for SSH and public HTTP"
  type        = list(string)
}

variable "ssh_security_group_name" {
  description = "SSH security group name"
  type        = string
}

variable "public_http_sg_name" {
  description = "Public HTTP security group name"
  type        = string
}

variable "private_http_sg_name" {
  description = "Private HTTP security group name"
  type        = string
}
