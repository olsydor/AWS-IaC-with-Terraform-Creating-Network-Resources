# ========================================
# Data Discovery Lab - EC2 Instance
# ========================================

resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [data.aws_security_group.main.id]

  associate_public_ip_address = true

  tags = {
    Name      = "${var.project_id}-instance"
    Terraform = "true"
    Project   = var.project_id
  }
}
