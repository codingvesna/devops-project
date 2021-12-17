terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile                 = "default"
  shared_credentials_file = "$HOME/.aws/credentials"
  region                  = var.aws_region
}