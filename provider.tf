terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_secretsmanager_secret_version" "db-creds" {
  secret_id = "db_creds"
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db-creds.secret_string)
}
