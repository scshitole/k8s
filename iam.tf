resource "aws_iam_role" "k8s" {
  name = "${var.prefix}-k8s-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "k8s" {
  name = "${var.prefix}-k8s"
  role = aws_iam_role.k8s.name
}
