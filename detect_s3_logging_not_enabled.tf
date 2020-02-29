provider "aws" {
  region = "us-east-1"
}

module "detect_s3_logging_not_enabled" {
  source           = "git@github.com:cloudmitigator/reflex.git//modules/cwe_lambda?ref=v0.2.0"
  rule_name        = "DetectS3LoggingNotEnabled"
  rule_description = "Rule to enforce S3 bucket logging"

  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.s3"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "CreateBucket"
    ]
  }
}
PATTERN

  function_name            = "DetectS3LoggingNotEnabled"
  source_code_dir          = "${path.module}/source"
  handler                  = "s3_logging_not_enabled.lambda_handler"
  lambda_runtime           = "python3.7"
  environment_variable_map = { SNS_TOPIC = var.sns_topic_arn }
  custom_lambda_policy     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketLogging"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF



  queue_name    = "DetectS3LoggingNotEnabled"
  delay_seconds = 60

  target_id = "DetectS3LoggingNotEnabled"

  sns_topic_arn = var.sns_topic_arn
}
