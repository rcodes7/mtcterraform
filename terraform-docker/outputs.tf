# #View them with (name must not contain spaces):
# #- terraform output
# #- terraform console > provide path of attribute youd like to see
# #- terraform show | grep ....

# output "ip-address" {
#   #  use for expression https://developer.hashicorp.com/terraform/language/expressions/for
#   value = flatten(module.container[*].ip-address)
#   description = "The ip address and external port of the container."
# }

# output "container-names" {
#   # splat expressions https://developer.hashicorp.com/terraform/language/expressions/splat
#   value = module.container[*].container-names
#   description = "The name of the container."
# }
