# Flow Logs for the Splunk VPC
resource "aws_flow_log" "splunk_vpc_flow_log" {
  log_destination          = aws_s3_bucket.flow_log_bucket.arn
  log_destination_type     = "s3"
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.splunk_vpc.id
  log_format               = "$${version} $${vpc-id} $${subnet-id} $${instance-id} $${interface-id} $${account-id} $${type} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${pkt-srcaddr} $${pkt-dstaddr} $${protocol} $${bytes} $${packets} $${start} $${end} $${action} $${tcp-flags} $${log-status}"
  max_aggregation_interval = "600"
}

# S3 bucket for VPC Flow logs
resource "aws_s3_bucket" "flow_log_bucket" {
  bucket = "${var.account_id}-lab-vpc-flow-logs"
}

output "splunk_vpc_log_id" {
  description = "The Flow Log ID"
  value       = aws_flow_log.splunk_vpc_flow_log.id
}
