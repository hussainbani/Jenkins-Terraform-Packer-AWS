data "aws_ami" "ami-api" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["ami-api-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}