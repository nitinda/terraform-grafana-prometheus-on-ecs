
### Public

resource "aws_route_table" "demo_route_table_public" {
  vpc_id = "${aws_vpc.demo_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo_internet_gateway.id}"
  }

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-route-table-public",
  ))}"
}

resource "aws_route_table_association" "demo_route_table_association_public" {
  count          = 2
  subnet_id      = "${element(aws_subnet.demo_subnet_public.*.id, count.index)}"
  route_table_id = "${aws_route_table.demo_route_table_public.id}"
}


### Private

resource "aws_route_table" "demo_route_table_private" {
  count  = 2
  vpc_id = "${aws_vpc.demo_vpc.id}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-route-table-private-${count.index}",
  ))}"
}

resource "aws_route" "demo_route_private" {
  count                  = 2
  route_table_id         = "${aws_route_table.demo_route_table_private.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.demo_nat_gateway.*.id[count.index]}"
  depends_on             = ["aws_route_table.demo_route_table_private"]
}

resource "aws_route_table_association" "demo_route_table_association_private" {
  count          = 2
  subnet_id      = "${element(aws_subnet.demo_subnet_private.*.id, count.index)}"
  route_table_id = "${aws_route_table.demo_route_table_private.*.id[count.index]}"
}


### Database

resource "aws_route_table" "demo_route_table_db" {
  vpc_id = "${aws_vpc.demo_vpc.id}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-ecs-route-table-db",
  ))}"
}

resource "aws_route_table_association" "demo_route_table_association_db" {
  count          = 2
  subnet_id      = "${element(aws_subnet.demo_subnet_db.*.id, count.index)}"
  route_table_id = "${aws_route_table.demo_route_table_db.id}"
}