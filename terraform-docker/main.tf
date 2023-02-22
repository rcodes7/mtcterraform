// https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
terraform {
  required_providers {
    docker = { // this is an alias that says that any resource that starts with docker, will use this provider
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

// leave empty since it is a local provider
provider "docker" {}



resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "random" {
  count = var.container_count
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container" {
  count = var.container_count #https://developer.hashicorp.com/terraform/language/meta-arguments/count
  name = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}
