resource "aws_cloudwatch_log_group" "dyn_fh_metricstream" {
  name       = "/aws/kinesisfirehose/DynatraceFireHoseMetricStream"
  kms_key_id = module.cwlogs_kms.kms_key_arn
}

resource "aws_cloudwatch_log_stream" "dyn_fh_metricstream" {
  name           = "httpendpointDelivery"
  log_group_name = aws_cloudwatch_log_group.dyn_fh_metricstream.name
}

resource "aws_kinesis_firehose_delivery_stream" "cw_metric_stream" {
  name        = "dynatrace-cw-firehose-stream"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = aws_iam_role.dyn_fh_stream_role.arn
    bucket_arn         = aws_s3_bucket.fh_faileddata_bucket.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  http_endpoint_configuration {
    url                = "https://aws.cloud.dynatrace.com/metrics"
    name               = "Dynatrace HTTP EndPoint"
    access_key         = jsondecode(data.aws_secretsmanager_secret_version.dynatrace_secrets.secret_string)["dynatrace_fh_token"]
    buffering_size     = 3
    buffering_interval = 60
    role_arn           = aws_iam_role.dyn_fh_stream_role.arn
    s3_backup_mode     = "FailedDataOnly"
    retry_duration     = 900

    request_configuration {
      content_encoding = "GZIP"

      common_attributes {
        name  = "dt-url"
        value = jsondecode(data.aws_secretsmanager_secret_version.dynatrace_secrets.secret_string)["dynatrace_url"]
      }

      common_attributes {
        name  = "require-valid-certificate"
        value = "true"
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.dyn_fh_metricstream.name
      log_stream_name = aws_cloudwatch_log_stream.dyn_fh_metricstream.name
    }

  }
}

resource "aws_cloudwatch_metric_stream" "cw_stream_dynatrace" {
  name          = var.stream_name
  role_arn      = aws_iam_role.metric_stream_to_firehose.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.cw_metric_stream.arn
  output_format = "opentelemetry0.7"

  dynamic "include_filter" {
    for_each = var.metrics
    iterator = item

    content {
      namespace = item.value
    }
  }
}