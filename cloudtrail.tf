resource "aws_cloudtrail" "lab_trail" {
  name                          = "lab_trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = false
  is_multi_region_trail         = false
}

output "lab_trail_id" {
  description = "The name of the trail"
  value       = aws_cloudtrail.lab_trail.id
}

output "lab_trail_region" {
  description = "The region in which the trail was created"
  value       = aws_cloudtrail.lab_trail.home_region
}

# Cloudtrail S3 bucket
resource "aws_s3_bucket" "trail_bucket" {
  bucket        = "${data.aws_caller_identity.current.account_id}-lab-cloudtrail-logs"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSbucketAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${data.aws_caller_identity.current.account_id}-lab-cloudtrail-logs"
        },
        {
            "Sid": "AWSbucketWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${data.aws_caller_identity.current.account_id}-lab-cloudtrail-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

output "trail_bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.trail_bucket.id
}

output "trail_bucket_region" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.trail_bucket.arn
}