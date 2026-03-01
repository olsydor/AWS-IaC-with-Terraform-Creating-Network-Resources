output "load_balancer_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app.dns_name
}

output "autoscaling_group_name" {
  description = "Name of the application auto scaling group"
  value       = aws_autoscaling_group.app.name
}
