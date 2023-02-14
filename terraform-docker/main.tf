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

resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}

resource "random_string" "random2" {
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container" {
  name = join("-", ["nodered", random_string.random.result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
#    external = 1880
  }
}

resource "docker_container" "nodered_container2" {
  name = join("-", ["nodered2", random_string.random2.result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
    #    external = 1880
  }
}


#View them with (name must not contain spaces):
#- terraform output
#- terraform console > provide path of attribute youd like to see
#- terraform show | grep ....

output "IP-Address" {
  value = join(":", [docker_container.nodered_container.network_data[0].ip_address,
    docker_container.nodered_container.ports[0].external])
  description = "The ip address and external port of the container."
}

output "container-names" {
  value = [docker_container.nodered_container.name, docker_container.nodered_container2.name]
  description = "The name of the container."
}
