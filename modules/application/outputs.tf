output "load_balancer_dns_name" {
  description = "DNS name of application load balancer"
  value       = aws_lb.app.dns_name
}
