region = "ap-southeast-1"
environment = "prod"

vpc_cidr = "10.0.0.0/16"

availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_app_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

db_subnets = [
  "10.0.21.0/24",
  "10.0.22.0/24"
]
allowed_ssh_cidr = [
  "180.151.204.174/32"
]
asg_min_size         = 2
asg_max_size         = 4
asg_desired_capacity = 2

db_name     = "company"
db_username = "admin"
db_password = "StrongPassword123!"
db_endpoint = "himanshu-dev-mysql-db.chscm2iiy2k4.ap-southeast-1.rds.amazonaws.com"
key_name = "him-key"

db_instance_class = "db.t3.micro"
db_allocated_storage = 20