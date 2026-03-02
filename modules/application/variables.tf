variable "project_id" {
  description = "Project identifier used in tags"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs used by ALB and ASG"
  type        = list(string)
}

variable "ssh_security_group_id" {
  description = "SSH security group ID"
  type        = string
}

variable "public_http_sg_id" {
  description = "Public HTTP security group ID"
  type        = string
}

variable "private_http_sg_id" {
  description = "Private HTTP security group ID"
  type        = string
}

variable "launch_template_name" {
  description = "Launch template name"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Autoscaling group name"
  type        = string
}

variable "load_balancer_name" {
  description = "Application load balancer name"
  type        = string
}

variable "target_group_name" {
  description = "Target group name"
  type        = string
}

variable "instance_type" {
  description = "Instance type used in launch template"
  type        = string
}

variable "desired_capacity" {
  description = "ASG desired capacity"
  type        = number
}

variable "min_size" {
  description = "ASG minimum size"
  type        = number
}

variable "max_size" {
  description = "ASG maximum size"
  type        = number
}
