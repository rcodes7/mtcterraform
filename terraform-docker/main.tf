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
  count = 2
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container" {
  count = 2 #https://developer.hashicorp.com/terraform/language/meta-arguments/count
  name = join("-", ["nodered", random_string.random[count.index].result])
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

output "IP-Address-0" {
  value = join(":", [docker_container.nodered_container[0].network_data[0].ip_address,
    docker_container.nodered_container[0].ports[0].external])
  description = "The ip address and external port of the container."
}

output "IP-Address-1" {
  value = join(":", [docker_container.nodered_container[1].network_data[0].ip_address,
    docker_container.nodered_container[1].ports[0].external])
  description = "The ip address and external port of the container."
}

output "container-names" {
  # splat expressions https://developer.hashicorp.com/terraform/language/expressions/splat
  value = docker_container.nodered_container[*].name
  description = "The name of the container."
}
