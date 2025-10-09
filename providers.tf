
terraform {
  
  required_version = ">= 1.0"
  
 
  required_providers {
    aws = {
      source  = "hashicorp/aws"  
      version = "~> 5.0"         
    }
  }

  
  backend "s3" {
  
    bucket = "ecommerce-terraform-using-aws-codesuite-state-dev"  
    key    = "terraform.tfstate"              
    region = "ap-south-1"                     
  }
}


provider "aws" {
  region = var.aws_region 
}
