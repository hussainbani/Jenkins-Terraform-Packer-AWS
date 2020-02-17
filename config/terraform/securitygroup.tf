
resource "aws_security_group" "node-web-lb" {
  name        = "node-web-lb"
  description = "Allow HTTP & HTTPS"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
}
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    task="toptal"
    Name = "node-web-lb"
    }
}

resource "aws_security_group" "node-api-lb" {
  name        = "node-api-lb"
  description = "Allow HTTP & HTTPS"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    task="toptal"
    Name = "node-api-lb"
    }
}

resource "aws_security_group" "node-api" {
  name        = "node-api"
  description = "Allow HTTP & HTTPS"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.node-api-lb.id}"]
  }

  egress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }

  tags = {
    task="toptal"
    Name = "node-api"
    }
}

resource "aws_security_group" "node-web" {
  name        = "node-web"
  description = "Allow HTTP & HTTPS"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.node-web-lb.id}"]
  }

  egress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }

  tags = {
    task="toptal"
    Name = "node-web"
    }
}

resource "aws_security_group" "RDS-sg" {
  name        = "RDS-sg"
  description = "Allow Postgres Connection"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    task= "toptal"
    Name = "RDS-sg"
    }
}