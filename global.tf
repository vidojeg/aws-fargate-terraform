terraform {
  backend "s3" {
    bucket  = "bc-fargate-test"
    key     = "fargate-test"
    region  = "eu-west-2"
  }
}

provider "aws" {
  region  = "eu-west-2"
}
