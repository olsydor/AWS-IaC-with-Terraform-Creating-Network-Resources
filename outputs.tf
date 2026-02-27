output "remote_state_instance_id" {
  description = "ID of the EC2 instance created using remote state outputs"
  value       = aws_instance.remote_state_ec2.id
}

output "remote_state_instance_public_ip" {
  description = "Public IP of the EC2 instance created using remote state outputs"
  value       = aws_instance.remote_state_ec2.public_ip
}
