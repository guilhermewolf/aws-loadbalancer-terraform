module "elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "${var.name}-elb"

  subnets         = module.vpc.public_subnets
  security_groups = [module.web_server_sg.this_security_group_id, module.alb_sg.this_security_group_id]
  internal        = false

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 4
    timeout             = 3
  }

  tags = {
    Name       = "${var.name}-elb"
    Provider   = "terraform"
    Enviroment = var.environment
  }
}

resource "aws_lb_cookie_stickiness_policy" "cookie_stickness" {
  name                     = "cookiestickness"
  load_balancer            = module.elb.this_elb_id
  lb_port                  = 80
  cookie_expiration_period = 600
}
