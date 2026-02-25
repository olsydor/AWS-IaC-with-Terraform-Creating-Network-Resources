output "vpc_id" {
  description = "The ID of the Virtual Private Cloud (VPC)"
  value       = aws_vpc.main.id
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
