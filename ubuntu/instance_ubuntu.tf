# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "Ubuntu"
data "aws_ami" "ubuntu_server" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ubuntu_instance" {
  ami           = data.aws_ami.ubuntu_server.id
  instance_type = "t2.micro"
  key_name      = "lab_kp"

  # VPC
  subnet_id = aws_subnet.lab_subnet_private.id

  # SG
  vpc_security_group_ids = [aws_security_group.lab_sg.id]
  user_data              = file("${path.module}/user_data_linux.sh")

  tags = {
    Name = "ubuntu"
  }
}

output "ubuntu_instance_id" {
  description = "Instance ID"
  value       = aws_instance.ubuntu_instance.id
}

output "ubuntu_instance_private_ip" {
  description = "Private IP"
  value       = aws_instance.ubuntu_instance.private_ip
}

# SG
resource "aws_security_group" "lab_sg" {
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.lab_vpc.id

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
    Name = "lab_sg"
  }
}

output "lab_sg" {
  description = "The ID of the security group"
  value       = aws_security_group.lab_sg.id
}
