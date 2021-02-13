module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"
  name    = "${var.name}-vpc"
  cidr    = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Provider   = "terraform"
    Enviroment = var.environment
  }
}
