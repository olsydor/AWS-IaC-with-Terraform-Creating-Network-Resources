resource "aws_security_group" "ssh" {
  name        = var.ssh_security_group_name
  description = "Allow SSH access"
  vpc_id      = var.vpc_id

  tags = {
    Name      = var.ssh_security_group_name
    Terraform = "true"
    Project   = var.project_id
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  count = length(var.allowed_ip_range)

  security_group_id = aws_security_group.ssh.id
  cidr_ipv4         = var.allowed_ip_range[count.index]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "ssh" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "public_http" {
  name        = var.public_http_sg_name
  description = "Allow public HTTP access"
  vpc_id      = var.vpc_id

  tags = {
    Name      = var.public_http_sg_name
    Terraform = "true"
    Project   = var.project_id
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_http" {
  count = length(var.allowed_ip_range)

  security_group_id = aws_security_group.public_http.id
  cidr_ipv4         = var.allowed_ip_range[count.index]
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "public_http" {
  security_group_id = aws_security_group.public_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "private_http" {
  name        = var.private_http_sg_name
  description = "Allow private HTTP from public HTTP security group"
  vpc_id      = var.vpc_id

  tags = {
    Name      = var.private_http_sg_name
    Terraform = "true"
    Project   = var.project_id
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_http" {
  security_group_id            = aws_security_group.private_http.id
  referenced_security_group_id = aws_security_group.public_http.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "private_http" {
  security_group_id = aws_security_group.private_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
