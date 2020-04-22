# CloudWatch Events Rule
resource "aws_cloudwatch_event_rule" "run_instances" {
  name        = "capture_run_instances"
  description = "Capture RunInstances event for Splunk Instance"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.cloudtrail"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "cloudtrail.amazonaws.com"
    ],
    "eventName": [
      "RunInstances"
    ]
  }
}
PATTERN
}

output "run_instances_cw_rule" {
    description = "The ARN of the CloudWatch Rule"
    value       = aws_cloudwatch_event_rule.run_instances.arn
}

# Targets
resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.run_instances.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.run_instances.arn
}

# SNS Topic
resource "aws_sns_topic" "run_instances" {
  name = "topic_run_instances"
}

# SNS policies that allow CloudWatch to publish to SNS Topic
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.run_instances.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [aws_sns_topic.run_instances.arn]
  }
}

output "run_instances_sns" {
    description = "The ID of the SNS topic"
    value       = aws_sns_topic.run_instances.id
}