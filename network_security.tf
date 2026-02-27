data "aws_network_interface" "public_primary" {
  filter {
    name   = "attachment.instance-id"
    values = [var.public_instance_id]
  }

  filter {
    name   = "attachment.device-index"
    values = ["0"]
  }
}

data "aws_network_interface" "private_primary" {
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
  name        = "cmtr-5bc36296-ssh-sg"
  description = "SSH and ICMP access from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "cmtr-5bc36296-ssh-sg"
    Project = "cmtr-5bc36296"
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
  name        = "cmtr-5bc36296-public-http-sg"
  description = "Public HTTP and ICMP access from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "cmtr-5bc36296-public-http-sg"
    Project = "cmtr-5bc36296"
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
  name        = "cmtr-5bc36296-private-http-sg"
  description = "Private HTTP and ICMP access from the public HTTP security group"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "cmtr-5bc36296-private-http-sg"
    Project = "cmtr-5bc36296"
  }
}

resource "aws_security_group_rule" "private_http_ingress_http_from_public_http_sg" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_http.id
  security_group_id        = aws_security_group.private_http.id
}

resource "aws_security_group_rule" "private_http_ingress_icmp_from_public_http_sg" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.public_http.id
  security_group_id        = aws_security_group.private_http.id
}

resource "aws_network_interface_sg_attachment" "public_instance_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_network_interface.public_primary.id
}

resource "aws_network_interface_sg_attachment" "public_instance_public_http" {
  security_group_id    = aws_security_group.public_http.id
  network_interface_id = data.aws_network_interface.public_primary.id
}

resource "aws_network_interface_sg_attachment" "private_instance_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_network_interface.private_primary.id
}

resource "aws_network_interface_sg_attachment" "private_instance_private_http" {
  security_group_id    = aws_security_group.private_http.id
  network_interface_id = data.aws_network_interface.private_primary.id
}
