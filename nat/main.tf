#--------------------------------------------------------------
# This module creates all resources necessary for NAT
#--------------------------------------------------------------

resource "aws_eip" "nat" {
  vpc   = true

  # 1 NAT per AZ
  count = "${length(split(",", var.azs))}" # Comment out count to only have 1 NAT

  lifecycle { create_before_destroy = true }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(split(",", var.public_subnet_ids), count.index)}"

  # 1 NAT per AZ
  count = "${length(split(",", var.azs))}" # Comment out count to only have 1 NAT

  tags { Name = "${var.environment}-${var.project}.nat.${element(split(",", var.azs), count.index)}" }
  lifecycle { create_before_destroy = true }
}
