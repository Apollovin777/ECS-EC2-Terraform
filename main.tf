terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
      bucket = "demoterraformsproject-777"
      key    = "ecs_ec2.tfstate"
      region = "us-east-1"  
  }
}

locals {
  name     = "ecs_test"  
  region   = "us-east-1"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default" 
}