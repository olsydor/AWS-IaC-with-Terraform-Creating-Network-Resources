# ========================================
# Data Discovery Lab - EC2 Instance
# ========================================

resource "aws_instance" "main" {
  count                  = var.enable_legacy_resources ? 1 : 0
  ami                    = data.aws_ami.amazon_linux[0].id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public[0].id
  vpc_security_group_ids = [data.aws_security_group.main[0].id]

  associate_public_ip_address = true

  tags = {
    Name      = "${var.project_id}-instance"
    Terraform = "true"
    Project   = var.project_id
  }
}
