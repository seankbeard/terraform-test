variable "monitoring_env" {
  description = "Dynatrace Monitoring Environment"
  type        = string
  validation {
    condition     = contains(["nonprod", "prod"], var.monitoring_env)
    error_message = "Allowed values for input_parameter are \"NonProd\" or \"Prod\"."
  }
}

variable "secrets_account" {
  description = "AWS Account to store secret"
  type        = string
}

variable "metrics" {
  description = "Metrics to send"
  type        = list(string)
}

variable "stream_name" {
  description = "Name for the CloudWatch Stream"
  type        = string
  default     = "cw-dynatrace-stream"
}
