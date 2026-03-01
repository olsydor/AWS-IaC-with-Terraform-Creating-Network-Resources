terraform {
  required_version = ">= 1.5.7"

  backend "s3" {
    bucket = "cmtr-5bc36296-backend-new-bucket-1772402415"
    key    = "tf_code.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
