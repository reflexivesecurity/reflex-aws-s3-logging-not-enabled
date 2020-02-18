resource "aws_s3_bucket" "log_bucket" {
  bucket        = "reflex-aws-detect-s3-logging-not-enabled-compliant-log"
  acl           = "log-delivery-write"
  force_destroy = true
}

resource "aws_s3_bucket" "complaint" {
  bucket        = "reflex-aws-detect-s3-logging-not-enabled-compliant"
  acl           = "private"
  force_destroy = true

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}

