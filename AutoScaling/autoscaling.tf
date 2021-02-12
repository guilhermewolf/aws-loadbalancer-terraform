module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "scale_group"

  # Launch configuration
  lc_name = "apache_webserver"

  image_id            = data.aws_ami.ubuntu_latest.id
  instance_type       = var.instance_type
  security_groups     = [module.web_server_sg.this_security_group_id]
  user_data           = file("bootstrap/install-apache.sh")
  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  #elb
  load_balancers = [module.elb.this_elb_id]
  # Auto scaling group
  asg_name            = "scale_group"
  vpc_zone_identifier = module.vpc.private_subnets
  health_check_type   = "ELB"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1

  tags = [
    {
      key                 = "Name"
      value               = "apache_webserver000"
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_policy" "autoscalingpolicy" {
  name                   = "terraform-autoscalepolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg.this_autoscaling_group_name
}

resource "aws_autoscaling_policy" "autoscalepolicy-down" {
  name                   = "terraform-autoscalepolicy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg.this_autoscaling_group_name
}
