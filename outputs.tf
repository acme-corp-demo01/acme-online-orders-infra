output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.web.public_ip
}

output "application_url" {
  description = "Demo application URL"
  value       = "http://${aws_instance.web.public_ip}"
}