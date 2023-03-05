terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "oridonner"
    workspaces {
      name = "filetype"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}