terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_network_interfaces" "public_eni" {
  count = var.public_instance_id != "" ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [var.public_instance_id]
  }

  filter {
    name   = "attachment.device-index"
    values = ["0"]
  }
}

data "aws_network_interfaces" "private_eni" {
  count = var.private_instance_id != "" ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [var.private_instance_id]
  }

  filter {
    name   = "attachment.device-index"
    values = ["0"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "${var.project_id}-ssh-sg"
  description = "Allow SSH and ICMP from allowed IP range"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.project_id}-ssh-sg"
    Project = var.project_id
  }
}

resource "aws_security_group_rule" "ssh_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group_rule" "ssh_ingress_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group" "public_http" {
  name        = "${var.project_id}-public-http-sg"
  description = "Allow public HTTP and ICMP from allowed IP range"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.project_id}-public-http-sg"
    Project = var.project_id
  }
}

resource "aws_security_group_rule" "public_http_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http.id
}

resource "aws_security_group_rule" "public_http_ingress_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http.id
}

resource "aws_security_group" "private_http" {
  name        = "${var.project_id}-private-http-sg"
  description = "Allow private HTTP and ICMP from public HTTP security group"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.project_id}-private-http-sg"
    Project = var.project_id
  }
}

resource "aws_security_group_rule" "private_http_ingress_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_http.id
  security_group_id        = aws_security_group.private_http.id
}

resource "aws_security_group_rule" "private_http_ingress_icmp" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.public_http.id
  security_group_id        = aws_security_group.private_http.id
}

locals {
  public_eni_id  = try(tolist(data.aws_network_interfaces.public_eni[0].ids)[0], "")
  private_eni_id = try(tolist(data.aws_network_interfaces.private_eni[0].ids)[0], "")
}

resource "aws_network_interface_sg_attachment" "public_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = local.public_eni_id
}

resource "aws_network_interface_sg_attachment" "public_http" {
  security_group_id    = aws_security_group.public_http.id
  network_interface_id = local.public_eni_id
}

resource "aws_network_interface_sg_attachment" "private_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = local.private_eni_id
}

resource "aws_network_interface_sg_attachment" "private_http" {
  security_group_id    = aws_security_group.private_http.id
  network_interface_id = local.private_eni_id
}