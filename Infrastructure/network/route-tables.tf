resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name        = "${terraform.workspace}-Pub"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.main.id}"
  }

  tags = {
    Name        = "${terraform.workspace}-Priv"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnet)}"
  subnet_id      = "${aws_subnet.subnet-public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.public_subnet)}"
  subnet_id      = "${aws_subnet.subnet-private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.id}"
}
