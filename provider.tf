terraform {
  backend "s3" {
    bucket = "niiadu12"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}