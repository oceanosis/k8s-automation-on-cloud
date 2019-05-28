# scale up alarm
# K8S MASTER ASG Policies
resource "aws_autoscaling_policy" "k8s-master-cpu-policy" {
  name                   = "k8s-master-cpu-policy"
  autoscaling_group_name = "${aws_autoscaling_group.k8s-master-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "k8s-master-cpu-alarm" {
  alarm_name          = "k8s-master-cpu-alarm"
  alarm_description   = "k8s-master-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.k8s-master-autoscaling.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.k8s-master-cpu-policy.arn}"]
}

# scale down alarm
resource "aws_autoscaling_policy" "k8s-master-cpu-policy-scaledown" {
  name                   = "k8s-master-cpu-policy-scaledown"
  autoscaling_group_name = "${aws_autoscaling_group.k8s-master-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "k8s-master-cpu-alarm-scaledown" {
  alarm_name          = "k8s-master-cpu-alarm-scaledown"
  alarm_description   = "k8s-master-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.k8s-master-autoscaling.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.k8s-master-cpu-policy-scaledown.arn}"]
}

# scale up alarm
# K8S WORKER ASG Policies
resource "aws_autoscaling_policy" "k8s-worker-cpu-policy" {
  name                   = "k8s-worker-cpu-policy"
  autoscaling_group_name = "${aws_autoscaling_group.k8s-worker-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "k8s-worker-cpu-alarm" {
  alarm_name          = "k8s-worker-cpu-alarm"
  alarm_description   = "k8s-worker-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.k8s-worker-autoscaling.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.k8s-worker-cpu-policy.arn}"]
}

# scale down alarm
resource "aws_autoscaling_policy" "k8s-worker-cpu-policy-scaledown" {
  name                   = "k8s-worker-cpu-policy-scaledown"
  autoscaling_group_name = "${aws_autoscaling_group.k8s-worker-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "k8s-worker-cpu-alarm-scaledown" {
  alarm_name          = "k8s-worker-cpu-alarm-scaledown"
  alarm_description   = "k8s-worker-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.k8s-worker-autoscaling.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.k8s-worker-cpu-policy-scaledown.arn}"]
}


