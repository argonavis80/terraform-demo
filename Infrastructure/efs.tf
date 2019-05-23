resource "aws_security_group" "center-node-efs" {
  name        = "${local.env_name_lowercase}-center-nodes-efs"
  description = "Security group for N4 center nodes EFS (${local.env_name_lowercase})."
  vpc_id      = "${module.network.vpc-id}"

  ingress {
    from_port = 32768
    to_port   = 65535
    protocol  = "6"

    security_groups = [
      "${aws_security_group.center-nodes.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "center-node" {
  creation_token = "${local.env_name_lowercase}-center-node"
}

resource "aws_efs_mount_target" "center-node" {
  file_system_id  = "${aws_efs_file_system.center-node.id}"
  subnet_id       = "${module.network.subnet-private-ids[2]}"
  security_groups = ["${aws_security_group.center-node-efs.id}"]
}
