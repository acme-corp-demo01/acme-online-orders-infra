variable "aws_region" {
  description = "AWS region for provisioning"
  type        = string
  default     = "ap-southeast-1" # Singapore - ASEAN territory
}

variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "instance_type" {
  description = "EC2 instance type - only t3.micro and t3.small approved for cost control"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type)
    error_message = "Instance type not approved. Submit a request to the Platform team for exception."
  }
}

variable "cost_center" {
  description = "Cost center for governance and chargeback"
  type        = string
  default     = "ecommerce"
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to access HTTP"
  type        = string
  default     = "0.0.0.0/0"
}