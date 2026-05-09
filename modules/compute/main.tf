data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "web" {
  name        = "acme-online-orders-${var.environment}-sg"
  description = "Security group for ACME online orders ${var.environment}"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP access for demo"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    description = "Outbound internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>ACME Online Orders 2.0- ${var.environment}</h1>" > /var/www/html/index.html
              echo "<p>Provisioned by Terraform Cloud v1</p>" >> /var/www/html/index.html
              EOF

  tags = merge(local.common_tags, {
    Name = "acme-online-orders-${var.environment}"
  })
}

locals {
  common_tags = {
    Application = "online-orders"
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "TerraformCloud"
    Owner       = "platform-team"
  }
}