# VPC
resource "aws_vpc" "splunk_vpc" {
  cidr_block = "192.168.0.0/24"
  enable_dns_hostnames = "true"
  instance_tenancy = "default"

  tags = {
    Name = "splunk_vpc"
  }
}

output "splunk_vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.splunk_vpc.arn
}

output "splunk_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.splunk_vpc.id
}

# Public Subnet
resource "aws_subnet" "splunk_subnet_public" {
  vpc_id                  = aws_vpc.splunk_vpc.id
  cidr_block              = "192.168.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone    = "us-east-1a"

  tags = {
    Name = "splunk_subnet_public"
  }
}

output "splunk_subnet_public" {
  description = "The ID of the public subnet"
  value       = aws_subnet.splunk_subnet_public.id
}

# Internet GW
resource "aws_internet_gateway" "splunk_gw" {
  vpc_id = aws_vpc.splunk_vpc.id

  tags = {
    Name = "splunk_gw"
  }
}

output "splunk_gw" {
  description = "The ID of the IGW"
  value       = aws_internet_gateway.splunk_gw.id
}

# Route Table
resource "aws_route_table" "splunk_route_table" {
  vpc_id = aws_vpc.splunk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.splunk_gw.id
  }

  tags = {
    Name = "splunk_route_table"
  }
}

output "splunk_route_table" {
  description = "The ID of the routing table"
  value       = aws_route_table.splunk_route_table.id
}

# Associate Route Table and Subnet
resource "aws_route_table_association" "splunk_route_table_subnet_public" {
  subnet_id      = aws_subnet.splunk_subnet_public.id
  route_table_id = aws_route_table.splunk_route_table.id
}

