# SSH Key Pair Configuration
# This resource manages the SSH key pair for EC2 instance access
# The public key is provided via the TF_VAR_ssh_key environment variable

resource "aws_key_pair" "cmtr-5bc36296-keypair" {
  key_name   = "cmtr-5bc36296-keypair"
  public_key = var.ssh_key

  tags = {
    Name    = "cmtr-5bc36296-keypair"
    Project = "epam-tf-lab"
    ID      = "cmtr-5bc36296"
  }
}
