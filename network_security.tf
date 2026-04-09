# SSH Security Group
resource "aws_security_group" "ssh_sg" {
  name        = "cmtr-5bc36296-ssh-sg"
  description = "Allow SSH from allowed IP range"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_ip_range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "cmtr-5bc36296"
  }
}

# Public HTTP Security Group
resource "aws_security_group" "public_http_sg" {
  name        = "cmtr-5bc36296-public-http-sg"
  description = "Allow HTTP from allowed IP range"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_ip_range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "cmtr-5bc36296"
  }
}

# Private HTTP Security Group
resource "aws_security_group" "private_http_sg" {
  name        = "cmtr-5bc36296-private-http-sg"
  description = "Allow HTTP and ICMP from Public HTTP Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from Public SG"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.public_http_sg.id]
  }

  ingress {
    description     = "Allow ICMP from Public SG"
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.public_http_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "cmtr-5bc36296"
  }
}

# Attach SG to Public Instance
resource "aws_network_interface_sg_attachment" "public_ssh_attachment" {
  security_group_id    = aws_security_group.ssh_sg.id
  network_interface_id = data.aws_instance.public_instance.network_interface_id
}

resource "aws_network_interface_sg_attachment" "public_http_attachment" {
  security_group_id    = aws_security_group.public_http_sg.id
  network_interface_id = data.aws_instance.public_instance.network_interface_id
}

# Attach SG to Private Instance
resource "aws_network_interface_sg_attachment" "private_ssh_attachment" {
  security_group_id    = aws_security_group.ssh_sg.id
  network_interface_id = data.aws_instance.private_instance.network_interface_id
}

resource "aws_network_interface_sg_attachment" "private_http_attachment" {
  security_group_id    = aws_security_group.private_http_sg.id
  network_interface_id = data.aws_instance.private_instance.network_interface_id
}

# Get network interfaces for the preexisting instances
data "aws_instance" "public_instance" {
  instance_id = var.public_instance_id
}

data "aws_instance" "private_instance" {
  instance_id = var.private_instance_id
}
