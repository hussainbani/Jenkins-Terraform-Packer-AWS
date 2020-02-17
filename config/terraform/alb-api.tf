resource "aws_elb" "API-ELB" {
  name = "API-ELB"
  security_groups = ["${aws_security_group.node-api-lb.id}"]
  subnets = ["${aws_subnet.Public-1.id}", "${aws_subnet.Public-2.id}", "${aws_subnet.Public-3.id}"]

  listener {
    instance_port = 80
    instance_protocol = "TCP"
    lb_port = 80
    lb_protocol = "TCP"
  }

  listener {
    instance_port = 443
    instance_protocol = "TCP"
    lb_port = 443
    lb_protocol = "TCP"
  }

  health_check {
    healthy_threshold = 2
    interval = 10
    target = "HTTP:80/api/status"
    timeout = 3
    unhealthy_threshold = 10
  }
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 300
  tags = {
    task = "toptal"
    Name = "API-ELB"
    }
}
