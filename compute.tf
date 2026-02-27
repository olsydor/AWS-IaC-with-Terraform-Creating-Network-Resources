data "aws_ami" "remote_state_amazon_linux_2" {
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

resource "aws_instance" "remote_state_ec2" {
  ami                         = data.aws_ami.remote_state_amazon_linux_2.id
  instance_type               = "t2.micro"
  subnet_id                   = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids      = [data.terraform_remote_state.base_infra.outputs.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name      = "${var.project_id}-remote-state-ec2"
    Terraform = "true"
    Project   = var.project_id
  }
}
