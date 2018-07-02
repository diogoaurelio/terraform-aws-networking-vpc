#--------------------------------------------------------------
# This module creates all networking resources
#--------------------------------------------------------------

module "vpc" {
  source = "./vpc"

  name        = "vpc"
  cidr        = "${var.vpc_cidr}"
  project     = "${var.project}"
  environment = "${var.environment}"
}

module "public_subnet" {
  source = "./public_subnet"

  name   = "${var.name}.public"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.public_subnets}"
  azs    = "${var.azs}"

  project     = "${var.project}"
  environment = "${var.environment}"
}

module "nat" {
  source = "./nat"

  name              = "${var.name}-nat"
  azs               = "${var.azs}"
  public_subnet_ids = "${module.public_subnet.subnet_ids}"

  project     = "${var.project}"
  environment = "${var.environment}"
}

module "private_subnet" {
  source = "./private_subnet"

  name   = "private"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.private_subnets}"
  azs    = "${var.azs}"

  project         = "${var.project}"
  environment     = "${var.environment}"
  nat_gateway_ids = "${module.nat.nat_gateway_ids}"
}

# The reason for this is that ephemeral nodes (nodes that are recycled often like ASG nodes),
# need to be in separate subnets from long-running nodes (like Elasticache and RDS) because
# AWS maintains an ARP cache with a semi-long expiration time.

# So if node A with IP 10.0.0.123 gets terminated, and node B comes in and picks up 10.0.0.123
# in a relatively short period of time, the stale ARP cache entry will still be there,
# so traffic will just fail to reach the new node.
module "ephemeral_subnets" {
  source = "./private_subnet"

  name   = "ephemeral.private"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.ephemeral_subnets}"
  azs    = "${var.azs}"

  project         = "${var.project}"
  environment     = "${var.environment}"
  nat_gateway_ids = "${module.nat.nat_gateway_ids}"
}

module "private_s3" {
  source = "./private_s3"

  vpc_id = "${module.vpc.vpc_id}"
  region = "${var.region}"

  environment     = "${var.environment}"
  route_table_ids = "${concat(module.public_subnet.route_table_ids, module.private_subnet.route_table_ids, module.ephemeral_subnets.route_table_ids)}"
}
