resource "aws_key_pair" "NODE-API-ssh-key" {
  key_name   = "NODE-API-ssh-key"
  public_key = file("${var.PATH_PUB_KEY}")
}


resource "aws_launch_configuration" "NODE-API-launchconfig" {
  name_prefix = "node-api-lc_"
  image_id = "${data.aws_ami.ami-api.id}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.NODE-API-ssh-key.key_name}"
  security_groups = ["${aws_security_group.node-api.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ec2-s3-profile.name}"
  root_block_device {
  volume_type = "gp2"
  volume_size = 60
  }
  user_data =<<-EOF
                 #!/bin/bash
                 echo "PORT=80" >> /etc/environment
                 echo "DB="postgres://${aws_db_instance.node-postgres.username}:${var.DB_PASS}@${aws_db_instance.node-postgres.endpoint}/${aws_db_instance.node-postgres.name}"" >> /etc/environment 
                 systemctl restart api.service
                EOF
lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "NODE-API-ASG" {
  name_prefix = "asg-${aws_launch_configuration.NODE-API-launchconfig.name}"
  launch_configuration = "${aws_launch_configuration.NODE-API-launchconfig.id}"
  vpc_zone_identifier  = ["${aws_subnet.Public-1.id}", "${aws_subnet.Public-2.id}", "${aws_subnet.Public-3.id}"]
  load_balancers = ["${aws_elb.API-ELB.name}"]
  health_check_type = "ELB"
  force_delete = "true"

  max_size = "${var.ASG_MAX}"
  min_size = "${var.ASG_MIN}"
  min_elb_capacity = "${var.ASG_MIN}"
  desired_capacity = "${var.ASG_DESIRED}"

  tag {
    propagate_at_launch = true
    key = "tier"
    value = "api"
  }
lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_lifecycle_hook" "ASG-API-LifeHook" {
  name                   = "ASG-API-LifeHook"
  autoscaling_group_name = "${aws_autoscaling_group.NODE-API-ASG.name}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 60
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

}