data "aws_ami" "ami-web" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["ami-web-*"]
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