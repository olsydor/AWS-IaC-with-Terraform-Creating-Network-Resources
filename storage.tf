resource "aws_s3_bucket" "cmtr-5bc36296-bucket" {
  count  = var.enable_legacy_resources ? 1 : 0
  bucket = "cmtr-5bc36296-bucket-1772098289"

  tags = {
    Project = "cmtr-5bc36296"
  }
}
