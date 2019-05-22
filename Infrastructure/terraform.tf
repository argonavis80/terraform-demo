variable "terraform_key" {
  description = "The key for the map of terraform role ARNs that should be used to execute this terraform script: terraform_read or terraform"
  default     = "terraform"
}

terraform {
  required_version = "~> 0.11.11"
}

provider "aws" {
  version = "~> 1.55"
  region  = "eu-west-3"

  assume_role {
    role_arn = "arn:aws:iam::419060205425:role/Terraform"
  }
}
