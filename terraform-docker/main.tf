
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

module "container" {
  source = "./container"
  depends_on = [
    null_resource.dockervol
  ]
  count = local.container_count #https://developer.hashicorp.com/terraform/language/meta-arguments/count
  name_in = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image_in = module.image.image_out
  int_port_in = var.int_port
  ext_port_in = var.ext_port[terraform.workspace][count.index]
  container_path_in = "/data"
  host_path_in = "${path.cwd}/noderedvol"
}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    # command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
    command = "mkdir noderedvol/ || true"
  }
}
