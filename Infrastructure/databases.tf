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

resource "aws_db_subnet_group" "subnet-group" {
  name       = "${local.env_name_lowercase}-db-subnet-group"
  subnet_ids = ["${module.network.subnet-private-ids}"]
}

# resource "aws_db_instance" "n4" {
#   identifier              = "${local.env_name_lowercase}-n4"
#   engine                  = "postgres"
#   instance_class          = "db.t3.micro"
#   storage_type            = "gp2"
#   allocated_storage       = 20
#   backup_retention_period = 0
#   multi_az                = 1
#   db_subnet_group_name    = "${aws_db_subnet_group.subnet-group.name}"
#   port                    = 5432
#   username                = "isadmin"
#   password                = "123geheim"
#   apply_immediately       = true
#   skip_final_snapshot     = true

#   vpc_security_group_ids = [
#     "${aws_security_group.n4-data.id}",
#   ]

#   tags = "${local.tags}"
# }

# resource "aws_db_instance" "billing" {
#   identifier              = "${local.env_name_lowercase}-billing"
#   engine                  = "postgres"
#   instance_class          = "db.t3.micro"
#   storage_type            = "gp2"
#   allocated_storage       = 20
#   backup_retention_period = 0
#   multi_az                = 1
#   db_subnet_group_name    = "${aws_db_subnet_group.subnet-group.name}"
#   port                    = 5432
#   username                = "isadmin"
#   password                = "123geheim"
#   apply_immediately       = true
#   skip_final_snapshot     = true

#   vpc_security_group_ids = [
#     "${aws_security_group.n4-data.id}",
#   ]

#   tags = "${local.tags}"
# }
