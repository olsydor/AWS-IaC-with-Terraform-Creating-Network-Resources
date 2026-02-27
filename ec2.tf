# Security Group Configuration
# This security group controls inbound and outbound traffic for EC2 instances

resource "aws_security_group" "cmtr-5bc36296-sg" {
  count = var.enable_legacy_resources ? 1 : 0

  name        = "cmtr-5bc36296-sg"
  description = "Security group for cmtr-5bc36296-ec2 instance"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "cmtr-5bc36296-sg"
    Project = "epam-tf-lab"
    ID      = "cmtr-5bc36296"
  }
}

# EC2 Instance Configuration
# This resource creates an EC2 instance with SSH key pair and security group

data "aws_ami" "amazon_linux_2" {
  count       = var.enable_legacy_resources ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "cmtr-5bc36296-ec2" {
  count                  = var.enable_legacy_resources ? 1 : 0
  ami                    = data.aws_ami.amazon_linux_2[0].id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.cmtr-5bc36296-keypair[0].key_name
  vpc_security_group_ids = [aws_security_group.cmtr-5bc36296-sg[0].id]
  subnet_id              = aws_subnet.public[0].id

  associate_public_ip_address = true

  tags = {
    Name    = "cmtr-5bc36296-ec2"
    Project = "epam-tf-lab"
    ID      = "cmtr-5bc36296"
  }

  depends_on = [
    aws_key_pair.cmtr-5bc36296-keypair,
    aws_security_group.cmtr-5bc36296-sg
  ]
}
