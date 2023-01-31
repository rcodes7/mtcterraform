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

resource "docker_container" "nodered_container" {
  name = "nodered"
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
    external = 1880
  }
}
