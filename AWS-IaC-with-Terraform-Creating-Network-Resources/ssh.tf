# SSH Key Pair Configuration
# This resource manages the SSH key pair for EC2 instance access
# The public key is provided via the TF_VAR_ssh_key environment variable

locals {
  ssh_key_is_valid = can(regex("^ssh-(rsa|ed25519|dss|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521)\\s+", trimspace(var.ssh_key)))
}

resource "tls_private_key" "cmtr-5bc36296-fallback" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "cmtr-5bc36296-keypair" {
  key_name   = "cmtr-5bc36296-keypair"
  public_key = local.ssh_key_is_valid ? trimspace(var.ssh_key) : tls_private_key.cmtr-5bc36296-fallback.public_key_openssh

  tags = {
    Name    = "cmtr-5bc36296-keypair"
    Project = "epam-tf-lab"
    ID      = "cmtr-5bc36296"
  }
}
