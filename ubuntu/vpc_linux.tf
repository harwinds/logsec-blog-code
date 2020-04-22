# VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lab_vpc"
  }
}

output "lab_vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.lab_vpc.arn
}

output "lab_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.lab_vpc.id
}

# Public Subnet
resource "aws_subnet" "lab_subnet_public" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "lab_subnet_public"
  }
}

output "lab_subnet_public" {
  description = "The ID of the public subnet"
  value       = aws_subnet.lab_subnet_public.id
}

# Private Subnet
resource "aws_subnet" "lab_subnet_private" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "lab_subnet_private"
  }
}

output "lab_subnet_private" {
  description = "The ID of the private subnet"
  value       = aws_subnet.lab_subnet_private.id
}

# Internet GW
resource "aws_internet_gateway" "lab_gw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "lab_gw"
  }
}

output "lab_gw" {
  description = "The ID of the IGW"
  value       = aws_internet_gateway.lab_gw.id
}

# Route Table
resource "aws_route_table" "lab_route_table" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_gw.id
  }

  tags = {
    Name = "lab_route_table"
  }
}

output "lab_route_table" {
  description = "The ID of the routing table"
  value       = aws_route_table.lab_route_table.id
}

# Associate Route Table and Subnet
resource "aws_route_table_association" "lab_route_table_subnet_public" {
  subnet_id      = aws_subnet.lab_subnet_public.id
  route_table_id = aws_route_table.lab_route_table.id
}

