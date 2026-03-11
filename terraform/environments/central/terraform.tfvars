aws_region           = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]
zone_name            = "example.com"
key_pair_name        = "Major"

# Fill these in after deploying QA and Prod environments
qa_alb_dns_name   = ""
qa_alb_zone_id    = ""
prod_alb_dns_name = ""
prod_alb_zone_id  = ""
qa_vpc_id         = ""
qa_account_id     = ""
prod_vpc_id       = ""
prod_account_id   = ""
