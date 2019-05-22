data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet-private" {
  count                   = "${length(var.private_subnet)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.private_subnet[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${terraform.workspace}-Priv-${count.index}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_subnet" "subnet-public" {
  count                   = "${length(var.public_subnet)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${terraform.workspace}-Pub-${count.index}"
    Environment = "${terraform.workspace}"
  }
}
