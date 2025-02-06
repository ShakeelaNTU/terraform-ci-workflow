terraform {
  required_version = ">= 0.12.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2"
    }
  }

  backend "s3" {
    bucket = "sctp-ce8-tfstate"
    key    = "shakee-s3-tf-ci.tfstate" # Change this if needed
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

provider "template" {}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = split("/", data.aws_caller_identity.current.arn)[1]
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "s3_tf" {
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
}
