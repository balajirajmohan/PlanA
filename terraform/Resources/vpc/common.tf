terraform {
    required_version = ">= 0.11.11"
    backend "s3" {
        bucket = "terraform-tfstate-ee"
        key    = "vpc/terraform.tfstate"
        region = "eu-west-2"
    }
}

provider "aws" {
    region     = var.aws_region
}