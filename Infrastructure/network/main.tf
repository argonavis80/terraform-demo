resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "${terraform.workspace}-VPC"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "${terraform.workspace}-IGW"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_eip" "nat-ip" {
  vpc = true

  tags = {
    Name        = "${terraform.workspace}-NAT-IP"
    Environment = "${terraform.workspace}"
  }

  depends_on = ["aws_internet_gateway.main"]
}

resource "aws_nat_gateway" "main" {
  allocation_id = "${aws_eip.nat-ip.id}"
  subnet_id     = "${aws_subnet.subnet-public.*.id[0]}"

  tags = {
    Name        = "${terraform.workspace}-NAT"
    Environment = "${terraform.workspace}"
  }

  depends_on = ["aws_internet_gateway.main"]
}
