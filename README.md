# Infrastracture for CloudWatch Metric Streams and delivering to Dynatrace
This module is designed to enable an easier path to setting up CloudWatch Metric Streams via AWS FireHose into Dynatrace.

The terrform module is based on the following CloudFormation script published by Dynatrace
https://dynatrace-aws-metric-streams-client.s3.amazonaws.com/dynatrace-aws-metric-streams-client.yaml

Additional References:
https://www.dynatrace.com/support/help/how-to-use-dynatrace/infrastructure-monitoring/cloud-platform-monitoring/amazon-web-services-monitoring/cloudwatch-metric-streams/

Module usage:
The module sets up the infrastructure components required for the integration. 
For this the only input required is to designate the Dynatrace Monitorin environment into which the stream will feed the metric data.
    - Prod or NonProd

## Usage

```hcl
module "dynatrace_custom_module" {
  source = "app.terraform.io/Kiwibank/dynatrace-aws-metric-streams-client/foundation"
  
  monitoring_env = "NonProd"
  metrics = [
    "AWS/EC2",
    "CustomNamespace"
    ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_monitoring_env"></a> [monitoring\_env](#input\_monitoring\_env) | Environment to Monitor(nonprod/prod). | `string` | `""` | yes |
| <a name="input_secrets_account"></a> [secrets\_account](#input\_secrets\_account) | AWS Account where Dynatrace Token is stored. | `string` | `"878978757310"` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | AWS Metrics to pass to Dynatrace. | `list` | `""` | yes |
| <a name="stream_name"></a> [stream\_name](#input\_stream\_name) | Cloudwatch Stream Name. | `string` | `"cw-dynatrace-stream"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firehose_arn"></a> [firehose\_arn](#output\_firehose\_arn) | Firehose ARN |
| <a name="output_fh_role_arn"></a> [fh\_role\_arn](#output\_fh\_role\_arn) | Firehose IAM Role ARN |git 