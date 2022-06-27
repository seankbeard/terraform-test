provider "aws" {
    region = "ap.southeast-2"
    default_tags {
        tags = local.common_tags
    }
}

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
