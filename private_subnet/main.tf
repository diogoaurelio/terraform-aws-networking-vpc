#--------------------------------------------------------------
# This module creates all resources necessary for a private
# subnet
#--------------------------------------------------------------

resource "aws_subnet" "private" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(split(",", var.cidrs), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = "${length(split(",", var.cidrs))}"

  # The subnet has to follow the naming convention name.public.eu-central-1a
  tags      { Name = "${var.environment}-${var.project}.${var.name}.${element(split(",", var.azs), count.index)}" }
  lifecycle { create_before_destroy = true }
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(split(",", var.cidrs))}"

  tags { Name = "${var.environment}-${var.project}.${var.name}.${element(split(",", var.azs), count.index)}" }
  lifecycle { create_before_destroy = true }
}

resource "aws_route" "default" {
  count = "${length(split(",", var.cidrs))}"

  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(split(",", var.nat_gateway_ids), count.index)}"

  depends_on = ["aws_route_table.private"]
}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.cidrs))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"

  lifecycle { create_before_destroy = true }
}
