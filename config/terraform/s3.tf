resource "aws_s3_bucket" "logs-toptal-test" {
  bucket = "logs-toptal-test"
  acl    = "private"
  force_destroy = true

  tags = {
    Name        = "logs-toptal-test"
    Environment = "Prod"
  }
}
resource "aws_s3_bucket" "toptal-artifact" {
  bucket = "toptal-artifact"
  acl    = "private"
  force_destroy = true

  tags = {
    Name        = "toptal-artifact"
    Environment = "Prod"
  }
}

