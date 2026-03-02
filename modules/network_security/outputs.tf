output "ssh_security_group_id" {
  description = "SSH security group ID"
  value       = aws_security_group.ssh.id
}

output "public_http_sg_id" {
  description = "Public HTTP security group ID"
  value       = aws_security_group.public_http.id
}

output "private_http_sg_id" {
  description = "Private HTTP security group ID"
  value       = aws_security_group.private_http.id
}
