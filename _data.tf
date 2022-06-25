data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_secretsmanager_secret" "dynatrace_secrets" {
  arn = "arn:aws:secretsmanager:ap-southeast-2:${var.secrets_account}:secret:/dynatrace/ingest_token_${var.monitoring_env}"
}

data "aws_secretsmanager_secret_version" "dynatrace_secrets" {
  secret_id = data.aws_secretsmanager_secret.dynatrace_secrets.id
}

data "aws_iam_policy_document" "kms_s3" {
  version = "2012-10-17"

  # https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:CreateAlias",
      "kms:CreateKey",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow use of key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.dyn_fh_stream_role.arn
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "kms_cloudwatch" {
  version = "2012-10-17"

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow CloudWatch to encrypt logs"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kinesisfirehose/DynatraceFireHoseMetricStream"]
    }
  }
}
