output "firehose_arn" {
  value = aws_kinesis_firehose_delivery_stream.cw_metric_stream.arn
}

output "fh_role_arn" {
  value = aws_iam_role.metric_stream_to_firehose.arn
}