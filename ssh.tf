# SSH Key Pair Configuration
# This resource manages the SSH key pair for EC2 instance access
# The public key is provided via the TF_VAR_ssh_key environment variable

locals {
  ssh_key_trimmed = trimspace(var.ssh_key)
  ssh_key_is_public = can(regex(
    "^ssh-(rsa|ed25519|dss|ecdsa-sha2-nistp(256|384|521))\\s+",
    local.ssh_key_trimmed
  ))
}

resource "tls_private_key" "cmtr-5bc36296-fallback" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "cmtr-5bc36296-keypair" {
  key_name   = "cmtr-5bc36296-keypair"
  public_key = local.ssh_key_is_public ? local.ssh_key_trimmed : tls_private_key.cmtr-5bc36296-fallback.public_key_openssh

  tags = {
    Name    = "cmtr-5bc36296-keypair"
    Project = "epam-tf-lab"
    ID      = "cmtr-5bc36296"
  }
}
