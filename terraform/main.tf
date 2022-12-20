terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "unstructured-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "unstructured_tf"
  }
}

provider "aws" {
  region  = var.region
}
