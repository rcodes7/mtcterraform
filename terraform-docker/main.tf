
provider "null" {
  # Configuration options
}


module "image" {
  source = "./image"
  image_in = var.image[terraform.workspace]
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
  name = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image = module.image.image_out
  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index]
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
