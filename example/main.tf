module "dynatrace_custom_module" {
  source = "../terraform-foundation-dynatrace-aws-metric-streams-client"
  
  monitoring_env = "NonProd"
  metrics = [
    "AWS/EC2",
    "CustomNamespace"
    ]
}
