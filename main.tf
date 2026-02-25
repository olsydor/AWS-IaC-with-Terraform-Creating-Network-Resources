terraform {
  backend "local" {
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      CreatedAt = timestamp()
    }
  }
}
