// https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
terraform {
  required_providers {
    docker = { // this is an alias that says that any resource that starts with docker, will use this provider
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

// leave empty since it is a local provider
provider "docker" {}

provider "null" {
  # Configuration options
}



resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "random" {
  count = local.container_count
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container" {
  count = local.container_count #https://developer.hashicorp.com/terraform/language/meta-arguments/count
  name = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  volumes {
    container_path = "/data"
    host_path = "${path.cwd}/noderedvol"
  }
}

# resource "null_resource" "dockervol" {
#   provisioner "local-exec" {
#     command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
#   }
# }
