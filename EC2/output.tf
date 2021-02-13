output "aws_lb" {
  description = "DNS Name of the ALB"
  value       = aws_lb.alb_ec2.dns_name
}
