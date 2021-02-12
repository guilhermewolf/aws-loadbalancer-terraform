output "aws_lb" {
  value = aws_lb.alb_ec2.dns_name
}
