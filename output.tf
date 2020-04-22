# output for splunk module
output "splunk_instance_id" {
  description = "Instance ID"
  value       = module.splunk.splunk_instance_id
}

output "splunk_instance_public_ip" {
  description = "Public IP"
  value       = module.splunk.splunk_instance_public_ip
}

output "splunk_instance_private_ip" {
  description = "Private IP"
  value       = module.splunk.splunk_instance_private_ip
}

output "splunk_sg" {
  description = "The ID of the security group"
  value       = module.splunk.splunk_sg
}

output "splunk_vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.splunk.splunk_vpc_arn
}

output "splunk_vpc_id" {
  description = "The ID of the VPC"
  value       = module.splunk.splunk_vpc_id
}

output "splunk_subnet_public" {
  description = "The ID of the public subnet"
  value       = module.splunk.splunk_subnet_public
}

output "splunk_gw" {
  description = "The ID of the IGW"
  value       = module.splunk.splunk_gw
}

output "splunk_route_table" {
  description = "The ID of the routing table"
  value       = module.splunk.splunk_route_table
}

output for ubuntu module
output "ubuntu_instance_id" {
  description = "Instance ID"
  value       = module.ubuntu.ubuntu_instance_id
}

output "ubuntu_instance_private_ip" {
  description = "Private IP"
  value       = module.ubuntu.ubuntu_instance_private_ip
}

output "lab_sg" {
  description = "The ID of the security group"
  value       = module.ubuntu.lab_sg
}

output "lab_vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.ubuntu.lab_vpc_arn
}

output "lab_vpc_id" {
  description = "The ID of the VPC"
  value       = module.ubuntu.lab_vpc_id
}

output "lab_subnet_public" {
  description = "The ID of the public subnet"
  value       = module.ubuntu.lab_subnet_public
}

output "lab_gw" {
  description = "The ID of the IGW"
  value       = module.ubuntu.lab_gw
}

output "lab_route_table" {
  description = "The ID of the routing table"
  value       = module.ubuntu.lab_route_table
}