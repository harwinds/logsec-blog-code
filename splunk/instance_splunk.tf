# Create a new instance of the latest Ubuntu 18.04 on an
# t2.micro node with an AWS Tag naming it "splunk"
data "aws_ami" "ubuntu_server" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "splunk_instance" {
   ami = data.aws_ami.ubuntu_server.id
   iam_instance_profile = aws_iam_instance_profile.splunk_instance_profile.name
   instance_type = "t2.medium"
   key_name = "lab_kp"

   # VPC
   subnet_id = aws_subnet.splunk_subnet_public.id

   # SG
   vpc_security_group_ids = [aws_security_group.splunk_sg.id]
   root_block_device {
     volume_type = "gp2"
     volume_size = 16
   }
   user_data = file("${path.module}/user_data_splunk.sh")

   tags = {
     Name = "splunk"
   }
 }

 output "splunk_instance_id" {
  description = "Instance ID"
  value       = aws_instance.splunk_instance.id
}

 output "splunk_instance_public_ip" {
  description = "Public IP"
  value       = aws_instance.splunk_instance.public_ip
}

 output "splunk_instance_private_ip" {
  description = "Private IP"
  value       = aws_instance.splunk_instance.private_ip
}

# SG
resource "aws_security_group" "splunk_sg" {
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.splunk_vpc.id

  ingress {
    description = "Splunk Port 8000 from Home Netowrk"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["${var.home_ip}/32"]
  }

  ingress {
    description = "SSH from Home Netowrk"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.home_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "splunk_sg"
  }
}

output "splunk_sg" {
  description = "The ID of the security group"
  value       = aws_security_group.splunk_sg.id
}
