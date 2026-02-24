module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_app_subnets = var.private_app_subnets
  db_subnets          = var.db_subnets
  availability_zones  = var.availability_zones
  environment         = var.environment
}

module "security" {
  source = "./modules/security"

  vpc_id           = module.vpc.vpc_id
  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "database" {
  source = "./modules/database"

  environment          = var.environment
  db_subnet_ids        = module.vpc.db_subnet_ids
  db_security_group_id = module.security.db_sg_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "compute" {
  source = "./modules/compute"

  environment            = var.environment
  public_subnet_ids      = module.vpc.public_subnet_ids
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  bastion_sg_id          = module.security.bastion_sg_id
  app_sg_id              = module.security.app_sg_id
  key_name               = var.key_name
  db_endpoint            = module.database.db_endpoint
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
}

module "alb" {
  source = "./modules/alb"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  app_asg_name      = module.compute.app_asg_name
}