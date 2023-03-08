# #View them with (name must not contain spaces):
# #- terraform output
# #- terraform console > provide path of attribute youd like to see
# #- terraform show | grep ....

output "application_access" {
  value = [for x in module.container[*]: x]
}
