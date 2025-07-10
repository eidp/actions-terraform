terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }
  # Provider functions require Terraform 1.8 and later.
  required_version = ">= 1.8.0"
}