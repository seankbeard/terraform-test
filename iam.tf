resource "aws_iam_role" "metric_stream_to_firehose" {
  name = "kb-dynatrace-cwmetricstream-to-firehose-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "streams.metrics.cloudwatch.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "metric_stream_to_firehose" {
  name = "kb-cwmetricstream-to-firehose-policy"
  role = aws_iam_role.metric_stream_to_firehose.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": "${aws_kinesis_firehose_delivery_stream.cw_metric_stream.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "dyn_fh_stream_role_policy" {
  name = "kb-dynatrace-firehose-role-policy"
  role = aws_iam_role.dyn_fh_stream_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.fh_faileddata_bucket.arn}",
                "${aws_s3_bucket.fh_faileddata_bucket.arn}/*"
            ]
        },
        {
           "Effect": "Allow",
           "Action": [
               "kms:Decrypt",
               "kms:GenerateDataKey"
           ],
           "Resource": [
               "${module.s3_kms.kms_key_arn}/${module.s3_kms.kms_key_id}"           
           ],
           "Condition": {
               "StringEquals": {
                   "kms:ViaService": "s3.region.amazonaws.com"
               },
               "StringLike": {
                   "kms:EncryptionContext:aws:s3:arn": "${aws_s3_bucket.fh_faileddata_bucket.arn}"
               }
           }
        },
        {
        "Action": [
          "logs:PutLogEvents"
        ],
        "Resource": [
          "${aws_cloudwatch_log_group.dyn_fh_metricstream.arn}"
        ],
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
EOF
}

resource "aws_iam_role" "dyn_fh_stream_role" {
  name               = "kb-dynatrace-firehose-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
