provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"

  project_id            = var.project_id
  vpc_name              = var.vpc_name
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnet_names   = var.public_subnet_names
  public_subnet_cidrs   = var.public_subnet_cidrs
  availability_zones    = var.availability_zones
  internet_gateway_name = var.internet_gateway_name
  route_table_name      = var.route_table_name
  allowed_ip_range      = var.allowed_ip_range
}

module "network_security" {
  source = "./modules/network_security"

  project_id              = var.project_id
  vpc_id                  = module.network.vpc_id
  allowed_ip_range        = var.allowed_ip_range
  ssh_security_group_name = var.ssh_security_group_name
  public_http_sg_name     = var.public_http_sg_name
  private_http_sg_name    = var.private_http_sg_name
}

module "application" {
  source = "./modules/application"

  project_id            = var.project_id
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.public_subnet_ids
  ssh_security_group_id = module.network_security.ssh_security_group_id
  public_http_sg_id     = module.network_security.public_http_sg_id
  private_http_sg_id    = module.network_security.private_http_sg_id

  launch_template_name   = var.launch_template_name
  autoscaling_group_name = var.autoscaling_group_name
  load_balancer_name     = var.load_balancer_name
  target_group_name      = var.target_group_name
  instance_type          = var.instance_type
  desired_capacity       = var.desired_capacity
  min_size               = var.min_size
  max_size               = var.max_size
}
