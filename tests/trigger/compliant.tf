data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "log_bucket" {
  bucket        = "${data.aws_caller_identity.current.account_id}-s3-log"
  acl           = "log-delivery-write"
  force_destroy = true
}

resource "aws_s3_bucket" "complaint" {
  bucket        = "${data.aws_caller_identity.current.account_id}-s3-src"
  acl           = "private"
  force_destroy = true

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}
