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


#View them with (name must not contain spaces):
#- terraform output
#- terraform console > provide path of attribute youd like to see
#- terraform show | grep ....

output "IP-Address" {
  value = docker_container.nodered_container.network_data[0].ip_address
  description = "The ip addressd of the container."
}

output "container-name" {
  value = docker_container.nodered_container.name
  description = "The name of the container."
}
