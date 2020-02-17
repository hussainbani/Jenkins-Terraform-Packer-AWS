resource "aws_key_pair" "NODE-WEB-ssh-key" {
  key_name   = "NODE-WEB-ssh-key"
  public_key = file("${var.PATH_PUB_KEY}")
}


resource "aws_launch_configuration" "NODE-WEB-launchconfig" {
  name_prefix = "node-web-lc_"
  image_id = "${data.aws_ami.ami-web.id}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.NODE-WEB-ssh-key.key_name}"
  security_groups = ["${aws_security_group.node-web.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ec2-s3-profile.name}"
  root_block_device {
  volume_type = "gp2"
  volume_size = 60
  }
  user_data =<<-EOF
                 #!/bin/bash
                 echo "PORT=80" >> /etc/environment
                 echo "API_HOST="${aws_elb.API-ELB.dns_name}"" >> /etc/environment
                 systemctl restart web.service
                EOF
lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "NODE-WEB-ASG" {
  name_prefix = "asg-${aws_launch_configuration.NODE-WEB-launchconfig.name}"
  launch_configuration = "${aws_launch_configuration.NODE-WEB-launchconfig.id}"
  vpc_zone_identifier  = ["${aws_subnet.Public-1.id}", "${aws_subnet.Public-2.id}", "${aws_subnet.Public-3.id}"]
  load_balancers = ["${aws_elb.WEB-ELB.name}"]
  health_check_type = "ELB"
  force_delete = "true"

  max_size = "${var.ASG_MAX}"
  min_size = "${var.ASG_MIN}"
  min_elb_capacity = "${var.ASG_MIN}"
  desired_capacity = "${var.ASG_DESIRED}"


  tag {
    propagate_at_launch = true
    key = "tier"
    value = "web"
  }
lifecycle {
    create_before_destroy = true
  }  
}

resource "aws_autoscaling_lifecycle_hook" "ASG-WEB-LifeHook" {
  name                   = "ASG-WEB-LifeHook"
  autoscaling_group_name = "${aws_autoscaling_group.NODE-WEB-ASG.name}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 60
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

}

