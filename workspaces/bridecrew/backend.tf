terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "dba3"
    workspaces {
        name = "bridgecrew_test"
        }
    }
}