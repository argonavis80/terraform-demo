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

resource "aws_alb" "ext" {
  name            = "${local.env_name_lowercase}-alb-ext"
  security_groups = ["${aws_security_group.alb-ext.id}"]
  subnets         = ["${module.network.subnet-public-ids}"]
  
  tags            = "${local.tags}"
}

resource "aws_alb_listener" "ext-listener" {
  load_balancer_arn = "${aws_alb.ext.arn}"
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