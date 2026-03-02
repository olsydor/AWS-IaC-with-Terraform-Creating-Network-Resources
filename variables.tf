variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_id" {
  description = "Project identifier for tags"
  type        = string
  default     = "cmtr-5bc36296"
}

variable "vpc_name" {
  description = "Pre-created VPC name"
  type        = string
  default     = "cmtr-5bc36296-vpc"
}

variable "public_subnet_1_name" {
  description = "First public subnet name"
  type        = string
  default     = "cmtr-5bc36296-public-subnet1"
}

variable "public_subnet_2_name" {
  description = "Second public subnet name"
  type        = string
  default     = "cmtr-5bc36296-public-subnet2"
}

variable "ssh_sg_name" {
  description = "Security group allowing SSH access"
  type        = string
  default     = "cmtr-5bc36296-sg-ssh"
}

variable "http_sg_name" {
  description = "Security group allowing HTTP access to instances"
  type        = string
  default     = "cmtr-5bc36296-sg-http"
}

variable "lb_sg_name" {
  description = "Security group allowing HTTP access to ALB"
  type        = string
  default     = "cmtr-5bc36296-sg-lb"
}

variable "blue_weight" {
  description = "The traffic weight for the Blue Target Group. Specifies the percentage of traffic routed to the Blue environment."
  type        = number
  default     = 100
}

variable "green_weight" {
  description = "The traffic weight for the Green Target Group. Specifies the percentage of traffic routed to the Green environment."
  type        = number
  default     = 0
}
