resource "aws_lb" "alb_ec2" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.web_server_sg.this_security_group_id, module.alb_sg.this_security_group_id]
  subnets            = module.vpc.public_subnets
  idle_timeout       = 400

  tags = {
    Name       = "${var.name}-alb"
    Provider   = "terraform"
    Enviroment = var.environment

  }
  depends_on = [module.vpc]
}

resource "aws_lb_target_group" "apache_tg" {
  name       = "${var.name}-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb_ec2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache_tg.arn
  }
  depends_on = [module.vpc]
}

resource "aws_lb_target_group_attachment" "apache_tg" {
  target_group_arn = aws_lb_target_group.apache_tg.arn
  target_id        = element(module.ec2-instance.id, 0)
  port             = 80
}
