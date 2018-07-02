# VPC
output "vpc_id"   { value = "${module.vpc.vpc_id}" }
output "vpc_cidr" { value = "${module.vpc.vpc_cidr}" }

# Subnets
output "public_subnet_ids"    { value = "${module.public_subnet.subnet_ids}" }
output "private_subnet_ids"   { value = "${module.private_subnet.subnet_ids}" }
output "ephemeral_subnet_ids" { value = "${module.ephemeral_subnets.subnet_ids}" }

# Routing tables
output "public_route_table_ids" { value = ["${module.public_subnet.route_table_ids}"] }
output "private_route_table_ids" { value = ["${module.private_subnet.route_table_ids}"] }
output "ephemeral_route_table_ids" { value = ["${module.ephemeral_subnets.route_table_ids}"] }

# NAT
output "nat_gateway_ids" { value = "${module.nat.nat_gateway_ids}" }

# VPC Endpoint for S3
output "private_s3_prefix_list_id" { value = "${module.private_s3.prefix_list_id}" }
