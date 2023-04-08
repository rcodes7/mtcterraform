terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "mtc-terraform-rr"

    workspaces {
      name = "mtc-dev"
    }
  }
}