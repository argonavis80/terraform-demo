resource "aws_security_group" "xps-servers" {
  name        = "${local.env_name_lowercase}-xps-servers"
  description = "Security group for XPS servers (${local.env_name_lowercase})."
  vpc_id      = "${module.network.vpc-id}"

  ingress {
    from_port = 32768
    to_port   = 65535
    protocol  = "6"

    security_groups = [
      "${aws_security_group.center-nodes.id}"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "xps-server" {
  instance_type               = "t3.micro"
  ami                         = "ami-0ebb3a801d5fb8b9b"
  subnet_id                   = "${module.network.subnet-private-ids[2]}"
  vpc_security_group_ids      = ["${aws_security_group.xps-servers.id}"]
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.n4-instance-profile.name}"

  tags = {
    Name        = "${local.env_name_lowercase}-xps-server"
    Application = "N4"
    Environment = "${local.env_name_lowercase}"
    CreatedBy   = "Terraform"
  }
}