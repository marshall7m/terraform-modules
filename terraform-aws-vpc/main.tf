resource "aws_security_group" "vpc_endpoints" {
  count = var.enable_s3_endpoint || var.enable_ec2messages_endpoint || var.enable_ec2_endpoint || var.enable_ssm_endpoint ? 1 : 0
  name        = var.vpc_endpoints_sg_name
  description = "Default security group for vpc endpoints"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"
  name = var.name
  cidr = var.cidr

  azs = var.azs
  
  private_subnets = var.private_subnets
  private_dedicated_network_acl = var.private_dedicated_network_acl
  private_subnet_suffix = var.private_subnet_suffix

  enable_s3_endpoint = var.enable_s3_endpoint

  enable_ec2messages_endpoint = var.enable_ec2messages_endpoint
  ec2messages_endpoint_security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  enable_ec2_endpoint = var.enable_ec2_endpoint
  ec2_endpoint_security_group_ids = [aws_security_group.vpc_endpoints[0].id]
  
  enable_ssm_endpoint = var.enable_ssm_endpoint
  ssm_endpoint_security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  enable_ssmmessages_endpoint = var.enable_ssmmessages_endpoint
  ssmmessages_endpoint_security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  create_database_subnet_route_table = var.create_database_subnet_route_table
  create_database_internet_gateway_route = var.create_database_internet_gateway_route
  create_database_subnet_group = var.create_database_subnet_group
   
  manage_default_network_acl = var.manage_default_network_acl 
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  
  private_inbound_acl_rules	= var.private_inbound_acl_rules
  
  private_outbound_acl_rules = var.private_outbound_acl_rules
  
  vpc_endpoint_tags =  var.vpc_endpoint_tags

  tags = var.tags
}
