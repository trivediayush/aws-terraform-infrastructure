output "instance_id" {
  description = "ID of the Lightsail instance"
  value       = aws_lightsail_instance.this.id
}

output "instance_name" {
  description = "Name of the Lightsail instance"
  value       = aws_lightsail_instance.this.name
}

output "public_ip_address" {
  description = "Public IP address of the Lightsail instance"
  value       = aws_lightsail_instance.this.public_ip_address
}

output "private_ip_address" {
  description = "Private IP address of the Lightsail instance"
  value       = aws_lightsail_instance.this.private_ip_address
}

output "availability_zone" {
  description = "Availability zone of the Lightsail instance"
  value       = aws_lightsail_instance.this.availability_zone
}

output "arn" {
  description = "ARN of the Lightsail instance"
  value       = aws_lightsail_instance.this.arn
}
