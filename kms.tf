# A key to encrypt the CloudWatch logs:
module "cwlogs_kms" {
  source      = "app.terraform.io/Kiwibank/kms/foundation"
  version     = "2.0.1"
  alias       = "DynatraceFireHoseMetricStream"
  description = "DynatraceFireHoseMetricStream"
  name        = "DynatraceFireHoseMetricStream"
  policy      = data.aws_iam_policy_document.kms_cloudwatch.json
}

module "s3_kms" {
  source      = "app.terraform.io/Kiwibank/kms/foundation"
  version     = "2.0.1"
  alias       = "DynatraceS3Bucket"
  description = "DynatraceS3Bucket"
  name        = "DynatraceS3Bucket"
  policy      = data.aws_iam_policy_document.kms_s3.json
}