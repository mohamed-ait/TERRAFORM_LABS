terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

    
provider "aws" {
  region     = "AWS_REGION"
  access_key = "AWS_ACCESS_KEY"
  secret_key = "AWS_SECRET_KEY"
}

// Generate a Private Key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

