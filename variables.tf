variable "aws_region" {
  description = "AWS region where resources are created"
  type        = string
  default     = "us-east-1"
}

variable "project_id" {
  description = "Project identifier used in names and tags"
  type        = string
  default     = "cmtr-5bc36296"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "cmtr-5bc36296-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_names" {
  description = "Names of public subnets"
  type        = list(string)
  default     = ["cmtr-5bc36296-subnet-public-a", "cmtr-5bc36296-subnet-public-b", "cmtr-5bc36296-subnet-public-c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for public subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "internet_gateway_name" {
  description = "Internet gateway name"
  type        = string
  default     = "cmtr-5bc36296-igw"
}

variable "route_table_name" {
  description = "Route table name"
  type        = string
  default     = "cmtr-5bc36296-rt"
}

variable "allowed_ip_range" {
  description = "List of IP address ranges for secure access"
  type        = list(string)
}

variable "ssh_security_group_name" {
  description = "Name of SSH security group"
  type        = string
  default     = "cmtr-5bc36296-ssh-sg"
}

variable "public_http_sg_name" {
  description = "Name of public HTTP security group"
  type        = string
  default     = "cmtr-5bc36296-public-http-sg"
}

variable "private_http_sg_name" {
  description = "Name of private HTTP security group"
  type        = string
  default     = "cmtr-5bc36296-private-http-sg"
}

variable "launch_template_name" {
  description = "Launch template name"
  type        = string
  default     = "cmtr-5bc36296-template"
}

variable "autoscaling_group_name" {
  description = "Autoscaling group name"
  type        = string
  default     = "cmtr-5bc36296-asg"
}

variable "load_balancer_name" {
  description = "Application load balancer name"
  type        = string
  default     = "cmtr-5bc36296-lb"
}

variable "target_group_name" {
  description = "Target group name"
  type        = string
  default     = "cmtr-5bc36296-tg"
}

variable "instance_type" {
  description = "EC2 instance type for application"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "ASG minimum size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "ASG maximum size"
  type        = number
  default     = 2
}
