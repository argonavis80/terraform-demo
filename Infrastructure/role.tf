resource "aws_iam_role" "n4-instance-role" {
  name               = "${local.env_name_lowercase}-n4-instance-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.n4-instance-policy.json}"
}

data "aws_iam_policy_document" "n4-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "n4-instance-profile" {
  name = "${local.env_name_lowercase}-n4-instance-profile"
  path = "/"
  role = "${aws_iam_role.n4-instance-role.id}"
}