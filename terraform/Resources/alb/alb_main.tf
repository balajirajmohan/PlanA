module "alb" {
  source                           = "git@github.com:nectar-uk/nectar-terraform-modules.git//terraform-aws-new-alb"
  load_balancer_name               = var.alb_name
  load_balancer_is_internal        = var.alb_is_internal
  security_groups                  = [aws_security_group.alb_sg.id]
  subnets                          = data.aws_subnet_ids.subnet_ids.ids
  idle_timeout                     = var.alb_idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  load_balancer_create_timeout     = var.load_balancer_create_timeout
  load_balancer_delete_timeout     = var.load_balancer_delete_timeout
  load_balancer_update_timeout     = var.load_balancer_update_timeout
  tags                             = var.tags
  logging_enabled                  = var.logging_enabled
  log_bucket_name                  = var.log_bucket_name
  log_location_prefix              = var.log_location_prefix
  vpc_id                           = data.aws_vpc.vpc.id
  target_groups                    = var.target_groups
  target_groups_count              = length(var.target_groups)
  http_tcp_listeners               = var.http_tcp_listeners
  http_tcp_listeners_count         = length(var.http_tcp_listeners)
  https_listeners                  = var.https_listeners
  https_listeners_count            = length(var.https_listeners)
}