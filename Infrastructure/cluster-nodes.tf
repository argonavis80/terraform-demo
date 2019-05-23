resource "aws_security_group" "cluster-nodes" {
  name        = "${local.env_name_lowercase}-cluster-nodes"
  description = "Security group for N4 cluster nodes (${local.env_name_lowercase})."
  vpc_id      = "${module.network.vpc-id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "6"

    security_groups = [
      "${aws_security_group.alb-int.id}",
      "${aws_security_group.alb-ext.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "cluster-node" {
  name_prefix                 = "${local.env_name_lowercase}-cluster-node-"
  image_id                    = "ami-088d2231f1df08c3d"
  instance_type               = "t3.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.n4-instance-profile.id}"
  associate_public_ip_address = false
  security_groups             = ["${aws_security_group.cluster-nodes.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cluster-nodes" {
  name                 = "${local.env_name_lowercase}-cluster-nodes"
  max_size             = "5"
  min_size             = "3"
  desired_capacity     = "3"
  vpc_zone_identifier  = ["${module.network.subnet-private-ids}"]
  launch_configuration = "${aws_launch_configuration.cluster-node.name}"
  health_check_type    = "EC2"
  target_group_arns    = ["${aws_alb_target_group.cluster-nodes.arn}"]
}

resource "aws_alb_target_group" "cluster-nodes" {
  name                 = "${local.env_name_lowercase}-cluster-nodes"
  vpc_id               = "${module.network.vpc-id}"
  port                 = 80
  protocol             = "HTTP"
  slow_start           = 30
  deregistration_delay = 60

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = "${local.tags}"
}

resource "aws_alb_listener_rule" "api_listener_rule" {
  listener_arn = "${aws_alb_listener.ext-listener.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.cluster-nodes.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}
