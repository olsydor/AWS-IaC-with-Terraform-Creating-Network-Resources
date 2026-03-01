output "load_balancer_dns_name" {
  description = "DNS name of the application load balancer"
  value       = try(aws_lb.app[0].dns_name, "")
}

output "autoscaling_group_name" {
  description = "Name of the application auto scaling group"
  value       = try(aws_autoscaling_group.app[0].name, "")
}

# Data Discovery Lab Outputs
output "vpc_id" {
  description = "ID of the discovered VPC"
  value       = try(data.aws_vpc.main.id, "")
}

output "public_subnet_id" {
  description = "ID of the discovered public subnet"
  value       = try(data.aws_subnet.public.id, "")
}

output "security_group_id" {
  description = "ID of the discovered security group"
  value       = try(data.aws_security_group.main.id, "")
}

output "ami_id" {
  description = "ID of the discovered AMI"
  value       = try(data.aws_ami.amazon_linux.id, "")
}

output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = try(aws_instance.main.id, "")
}

output "instance_public_ip" {
  description = "Public IP of the created EC2 instance"
  value       = try(aws_instance.main.public_ip, "")
}
