terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.25.0"
    }
  }

  backend "s3" {
    bucket = "mybytesni-terraform-state"
    key = "profile_api_infrastructure/root/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "mybytesni-terraform-state"
    encrypt = true
  }
}


provider "aws" {
  region  = "us-east-1"
}

