resource "aws_launch_configuration" "k8s-master-launchconfig" {
  name_prefix          = "k8s-master-launchconfig"
  image_id             = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${aws_key_pair.mykeypair.key_name}"
  security_groups      = ["${aws_security_group.public-sg.id}"]
}

resource "aws_autoscaling_group" "k8s-master-autoscaling" {
  name                 = "k8s-master-autoscaling"
  vpc_zone_identifier  = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  launch_configuration = "${aws_launch_configuration.k8s-master-launchconfig.name}"
  min_size             = 1
  max_size             = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true

  tag {
      key = "Name"
      value = "K8S Master"
      propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "k8s-worker-launchconfig" {
  name_prefix          = "k8s-worker-launchconfig"
  image_id             = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${aws_key_pair.mykeypair.key_name}"
  security_groups      = ["${aws_security_group.public-sg.id}"]
}

resource "aws_autoscaling_group" "k8s-worker-autoscaling" {
  name                 = "k8s-worker-autoscaling"
  vpc_zone_identifier  = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  launch_configuration = "${aws_launch_configuration.k8s-worker-launchconfig.name}"
  min_size             = 2
  max_size             = 3
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true

  tag {
      key = "Name"
      value = "K8S Worker"
      propagate_at_launch = true
  }
}

