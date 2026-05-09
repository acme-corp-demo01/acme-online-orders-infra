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

data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
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
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo '<html>' > /var/www/html/index.html
              echo '<head><title>ACME Corp</title></head>' >> /var/www/html/index.html
              echo '<body style="font-family:Arial; text-align:center; padding:50px; background:#f4f4f4">' >> /var/www/html/index.html
              echo '<h1 style="color:#5C4EE5">ACME Corp — Online Orders 2.0</h1>' >> /var/www/html/index.html
              echo "<p style='font-size:20px'>Environment: <strong>${var.environment}</strong></p>" >> /var/www/html/index.html
              echo '<p style="color:#666">Provisioned by Terraform Cloud | Region: ap-southeast-1</p>' >> /var/www/html/index.html
              echo '<p style="color:#888; font-size:14px">ManagedBy: TerraformCloud | Owner: platform-team</p>' >> /var/www/html/index.html
              echo '</body></html>' >> /var/www/html/index.html
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