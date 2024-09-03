terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.1"
    }
  }
 
  backend "s3" {
    bucket         = "rmg-tf-backends"
    key            = "rodneygagnon.com/envs/dev/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "rmg-tf-backends"
    profile        = "rmg-west"
  }
}

provider "aws" {
  region  = var.default_region
  profile = "rmg-west"
}