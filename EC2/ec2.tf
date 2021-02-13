module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.name}-webserver"
  instance_count = 1

  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = var.instance_type
  monitoring             = false
  user_data              = file("bootstrap/install_apache.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3_iam_profile.name
  vpc_security_group_ids = [module.web_server_sg.this_security_group_id]
  subnet_ids             = module.vpc.private_subnets

  tags = {
    Provider   = "terraform"
    Enviroment = var.environment
  }
  depends_on = [module.vpc]
}
