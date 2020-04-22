# Provides an AWS IAM Role
resource "aws_iam_role" "splunk_iam_role" {
  name = "splunk_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

output "splunk_iam_role_arn" {
  description = "The ARN of the Role"
  value       = aws_iam_role.splunk_iam_role.arn
}

# Provides an AWS IAM Role Policy
resource "aws_iam_role_policy" "splunk_iam_policy" {
  name = "splunk_policy"
  role = aws_iam_role.splunk_iam_role.id

  policy = file("${path.module}/splunk_iam_role_pol.json")
}

# Provides an IAM instance profile for Splunk isntance
resource "aws_iam_instance_profile" "splunk_instance_profile" {
  name = "splunk_instance_profile"
  role = aws_iam_role.splunk_iam_role.name
}

output "splunk_instance_profile_name" {
  description = "The instance profile's name"
  value       = aws_iam_instance_profile.splunk_instance_profile.name
}