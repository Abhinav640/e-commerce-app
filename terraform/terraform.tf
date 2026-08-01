terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.52.0, < 7.0.0"
    }
  }

  backend "s3" {
    bucket         = "state-bucket1994"
    key            = "state/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    use_lockfile   = true
  }
}