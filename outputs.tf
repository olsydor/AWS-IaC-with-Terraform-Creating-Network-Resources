output "vpc_id" {
  description = "The ID of the Virtual Private Cloud (VPC)"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block associated with the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = aws_vpc.main.tags["Name"]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway attached to the VPC"
  value       = aws_internet_gateway.main.id
}

output "internet_gateway_name" {
  description = "The name of the Internet Gateway"
  value       = aws_internet_gateway.main.tags["Name"]
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets created across availability zones"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidr_block" {
  description = "Set of CIDR blocks for all public subnets"
  value       = toset(aws_subnet.public[*].cidr_block)
}

output "public_subnet_availability_zone" {
  description = "Set of availability zones for all public subnets"
  value       = toset(aws_subnet.public[*].availability_zone)
}

output "public_subnet_info" {
  description = "Detailed information about public subnets"
  value = [
    for subnet in aws_subnet.public : {
      id                = subnet.id
      name              = subnet.tags["Name"]
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  ]
}

output "public_route_table_id" {
  description = "The ID of the route table for public subnets"
  value       = aws_route_table.public.id
}

output "routing_table_id" {
  description = "The unique identifier of the routing table"
  value       = aws_route_table.public.id
}

output "public_route_table_name" {
  description = "The name of the route table for public subnets"
  value       = aws_route_table.public.tags["Name"]
}

output "route_table_association_ids" {
  description = "The IDs of the route table associations for public subnets"
  value       = aws_route_table_association.public[*].id
}

output "network_summary" {
  description = "Summary of the created network infrastructure"
  value = {
    vpc_id           = aws_vpc.main.id
    vpc_name         = aws_vpc.main.tags["Name"]
    vpc_cidr_block   = aws_vpc.main.cidr_block
    igw_id           = aws_internet_gateway.main.id
    igw_name         = aws_internet_gateway.main.tags["Name"]
    subnets_count    = length(aws_subnet.public)
    route_table_id   = aws_route_table.public.id
    route_table_name = aws_route_table.public.tags["Name"]
  }
}

# SSH Key Pair Output
output "key_pair_id" {
  description = "The name of the SSH key pair"
  value       = aws_key_pair.cmtr-5bc36296-keypair.key_name
}

output "key_pair_fingerprint" {
  description = "The fingerprint of the SSH key pair"
  value       = aws_key_pair.cmtr-5bc36296-keypair.fingerprint
}

# Security Group Output
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.cmtr-5bc36296-sg.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.cmtr-5bc36296-sg.name
}

# EC2 Instance Outputs
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.cmtr-5bc36296-ec2.id
}

output "ec2_instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.cmtr-5bc36296-ec2.public_ip
}

output "ec2_instance_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.cmtr-5bc36296-ec2.public_dns
}

output "ec2_instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.cmtr-5bc36296-ec2.private_ip
}

output "ec2_instance_key_name" {
  description = "The key pair name associated with the EC2 instance"
  value       = aws_instance.cmtr-5bc36296-ec2.key_name
}

output "ssh_access_summary" {
  description = "Summary of SSH access information for the EC2 instance"
  value = {
    instance_id    = aws_instance.cmtr-5bc36296-ec2.id
    public_ip      = aws_instance.cmtr-5bc36296-ec2.public_ip
    key_pair_name  = aws_key_pair.cmtr-5bc36296-keypair.key_name
    security_group = aws_security_group.cmtr-5bc36296-sg.name
    ssh_command    = "ssh -i <private-key-file> ec2-user@${aws_instance.cmtr-5bc36296-ec2.public_ip}"
  }
}
