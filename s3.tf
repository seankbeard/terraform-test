resource "aws_s3_bucket" "fh_faileddata_bucket" {
  bucket = "kb-${data.aws_caller_identity.current.account_id}-dynatrace-fh-faileddata"
  #acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = module.s3_kms.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}

# Disable public bucket access
resource "aws_s3_bucket_public_access_block" "fh_faileddata_bucket" {
  bucket = aws_s3_bucket.fh_faileddata_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
