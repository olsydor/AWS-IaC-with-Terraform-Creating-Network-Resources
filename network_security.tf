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

data "aws_instance" "public" {
  count       = var.public_instance_id != "" ? 1 : 0
  instance_id = var.public_instance_id
}

data "aws_instance" "private" {
  count       = var.private_instance_id != "" ? 1 : 0
  instance_id = var.private_instance_id
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
  public_eni_id  = coalesce(var.public_network_interface_id, try(data.aws_instance.public[0].network_interface_id, ""))
  private_eni_id = coalesce(var.private_network_interface_id, try(data.aws_instance.private[0].network_interface_id, ""))
}

resource "aws_network_interface_sg_attachment" "public_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = local.public_eni_id
}

resource "aws_network_interface_sg_attachment" "public_http" {
  depends_on           = [aws_network_interface_sg_attachment.public_ssh]
  security_group_id    = aws_security_group.public_http.id
  network_interface_id = local.public_eni_id
}

resource "aws_network_interface_sg_attachment" "private_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = local.private_eni_id
}

resource "aws_network_interface_sg_attachment" "private_http" {
  depends_on           = [aws_network_interface_sg_attachment.private_ssh]
  security_group_id    = aws_security_group.private_http.id
  network_interface_id = local.private_eni_id
}