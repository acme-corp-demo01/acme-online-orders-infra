variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "cost_center" {
  description = "Cost center for governance"
  type        = string
}

variable "allowed_http_cidr" {
  description = "CIDR allowed for HTTP access"
  type        = string
}