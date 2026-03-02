output "alb_dns_name" {
  description = "DNS name of the blue-green ALB"
  value       = aws_lb.main.dns_name
}

output "blue_asg_name" {
  description = "Blue ASG name"
  value       = aws_autoscaling_group.blue.name
}

output "green_asg_name" {
  description = "Green ASG name"
  value       = aws_autoscaling_group.green.name
}
