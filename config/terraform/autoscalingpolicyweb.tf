resource "aws_autoscaling_policy" "NODE-WEB-CPU-UP-Policy" {
  name                   = "NODE-WEB-CPU-UP-Policy"
  scaling_adjustment     = 1
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.NODE-WEB-ASG.name}"
  policy_type = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
}
resource "aws_cloudwatch_metric_alarm" "NODE-WEB-CPU-UP-Alarm" {
  alarm_name                = "NODE-WEB-CPU-UP-Alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "75"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.NODE-WEB-ASG.name}"
}
  alarm_actions     = ["${aws_autoscaling_policy.NODE-WEB-CPU-UP-Policy.arn}"]
}

resource "aws_autoscaling_policy" "NODE-WEB-CPU-Down-Policy" {
  name                   = "NODE-WEB-CPU-Down-Policy"
  scaling_adjustment     = -1
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.NODE-WEB-ASG.name}"
  policy_type = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
}

resource "aws_cloudwatch_metric_alarm" "NODE-WEB-CPU-Down-Alarm" {
  alarm_name                = "NODE-WEB-CPU-Down-Alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "25"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.NODE-WEB-ASG.name}"
}
  alarm_actions     = ["${aws_autoscaling_policy.NODE-WEB-CPU-Down-Policy.arn}"]
}
