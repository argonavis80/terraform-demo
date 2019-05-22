resource "aws_iam_role" "cluster-node-instance-role" {
  name               = "${local.env_name_lowercase}-cluster-node-instance-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.cluster-node-instance-policy.json}"
}

data "aws_iam_policy_document" "cluster-node-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "cluster-node-instance-profile" {
  name = "${local.env_name_lowercase}-cluster-node-instance-profile"
  path = "/"
  role = "${aws_iam_role.cluster-node-instance-role.id}"
}