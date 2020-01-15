# data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "non-compliant" {
  bucket        = "${data.aws_caller_identity.current.account_id}-s3-normal"
  acl           = "private"
  force_destroy = true
}
