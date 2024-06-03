# output "default_route_table_id" {
#   value = data.aws_route_table.default.id
# }

# Note: "we commented this once we run terrafrom apply -var-file="dev.tfvars" to fetch default route_table_id and written 
# aws_route configuration in network.tf to route routable to attach with aws_internet_gateway"