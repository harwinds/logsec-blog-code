# Add Amazon S3 Event Notification configuration to SQS Queue
resource "aws_sqs_queue" "queue" {
  name                       = "s3_event_notification_queue"
  visibility_timeout_seconds = 300
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dl_queue.arn
    maxReceiveCount     = 1
  })

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:s3_event_notification_queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.trail_bucket.arn}" }
      }
    }
  ]
}
POLICY
}

# Set up a dead-letter queue for the SQS queue to be used for the input for storing invalid messages
resource "aws_sqs_queue" "dl_queue" {
  name = "dl_queue_error_messages"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.trail_bucket.id

  queue {
    queue_arn = aws_sqs_queue.queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

output "sqs_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.queue.arn
}

