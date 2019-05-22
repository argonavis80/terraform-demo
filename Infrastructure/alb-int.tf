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

resource "aws_alb" "int" {
  name            = "${local.env_name_lowercase}-alb-int"
  security_groups = ["${aws_security_group.alb-int.id}"]
  subnets         = ["${module.network.subnet-public-ids}"]
  
  tags            = "${local.tags}"
}

resource "aws_alb_listener" "int-listener" {
  load_balancer_arn = "${aws_alb.int.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}