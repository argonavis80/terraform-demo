output subnet-public-ids {
  value = "${aws_subnet.subnet-public.*.id}"
}

output subnet-private-ids {
  value = "${aws_subnet.subnet-private.*.id}"
}

output vpc-id {
  value = "${aws_vpc.main.id}"
}
