data "terraform_remote_state" "base_infra" {
  count   = var.enable_remote_state_lab ? 1 : 0
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = var.state_key
    region = var.aws_region
  }
}
