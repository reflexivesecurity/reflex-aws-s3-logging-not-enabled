resource "aws_s3_bucket" "non-compliant" {
  bucket        = "reflex-aws-detect-s3-logging-not-enabled-non-compliant"
  acl           = "private"
  force_destroy = true
}

