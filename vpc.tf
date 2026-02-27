# Create VPC
resource "aws_vpc" "main" {
  count = var.enable_legacy_resources ? 1 : 0

  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.vpc_name
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  count = var.enable_legacy_resources ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = {
    Name = var.internet_gateway_name
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = var.enable_legacy_resources ? length(var.availability_zones) : 0
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.enable_public_ip_on_launch

  tags = {
    Name = var.public_subnet_names[count.index]
    Type = "Public"
  }

  depends_on = [aws_vpc.main]
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public" {
  count = var.enable_legacy_resources ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = {
    Name = var.route_table_name
    Type = "Public"
  }

  depends_on = [aws_internet_gateway.main]
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  count          = var.enable_legacy_resources ? length(var.availability_zones) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}
