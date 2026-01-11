terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.25.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-kjdhakhdkashdak"

  tags = {
    Name        = "My bucket terraform"
    Environment = "Stage"
  }
}