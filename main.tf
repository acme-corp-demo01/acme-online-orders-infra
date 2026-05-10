terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "acme-corp-platform"

    workspaces {
      project = "online-orders-platform"

      tags = {
        workspace-group = "acme-online-orders"
      }
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "online_orders_compute" {
  source = "./modules/compute"

  environment       = var.environment
  instance_type     = var.instance_type
  cost_center       = var.cost_center
  allowed_http_cidr = var.allowed_http_cidr
}