resource "aws_security_group" "alb-int" {
  name        = "${local.env_name_lowercase}-alb-int"
  description = "Security group for ALB (INT) (${local.env_name_lowercase})."
  vpc_id      = "${module.network.vpc-id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb-ext" {
  name        = "${local.env_name_lowercase}-alb-ext"
  description = "Security group for ALB (EXT) (${local.env_name_lowercase})."
  vpc_id      = "${module.network.vpc-id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cluster-nodes" {
  name        = "${local.env_name_lowercase}-cluster-nodes"
  description = "Security group for N4 cluster nodes (${local.env_name_lowercase})."
  vpc_id      = "${module.network.vpc-id}"

  ingress {
    from_port = 32768
    to_port   = 65535
    protocol  = "6"

    security_groups = [
      "${aws_security_group.alb-int.id}",
      "${aws_security_group.alb-ext.id}"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "n4-data" {
  name        = "${local.env_name_lowercase}-n4-data"
  description = "Security group for N4 data tier (${local.env_name_lowercase})."
  vpc_id      = "${module.network.vpc-id}"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "6"

    security_groups = [
      "${aws_security_group.cluster-nodes.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
