locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service = "bridgecrew_testing"
    Owner   = "Sean"
  }
  resource_prefix = "bridgecrew_testing"
}

