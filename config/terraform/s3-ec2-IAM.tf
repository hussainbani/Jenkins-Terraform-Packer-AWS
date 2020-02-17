resource "aws_iam_role" "ec2-s3" {
  name = "ec2-s3"

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

  tags = {
    tag-key = "ec2-s3"
  }
}

resource "aws_iam_instance_profile" "ec2-s3-profile" {
  name = "ec2-s3-profile"
  role = "${aws_iam_role.ec2-s3.name}"
}


resource "aws_iam_role_policy" "s3-full-access-hussain" {
  name = "s3-full-access-hussain"
  role = "${aws_iam_role.ec2-s3.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

