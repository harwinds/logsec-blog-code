# Configure S3 Block Public Access on the AWS account level (applies to all S3 buckets in all regions). 

resource "aws_s3_account_public_access_block" "BlockPublicAccess" {
  block_public_acls       = "true"
  ignore_public_acls      = "true"
  block_public_policy     = "true"
  restrict_public_buckets = "true"
}