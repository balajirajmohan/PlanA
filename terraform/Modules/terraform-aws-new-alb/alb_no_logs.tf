resource "aws_lb" "application_no_logs" {
  load_balancer_type               = "application"
  name                             = var.load_balancer_name
  internal                         = var.load_balancer_is_internal
  security_groups                  = var.security_groups
  subnets                          = var.subnets
  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type

  tags = merge(
    var.tags,
    {
      "Name" = var.load_balancer_name
    },
  )

  timeouts {
    create = var.load_balancer_create_timeout
    delete = var.load_balancer_delete_timeout
    update = var.load_balancer_update_timeout
  }

  count = var.create_alb && false == var.logging_enabled ? 1 : 0
}

module "tg_main_no_logs" {
  source                    = "../terraform-aws-new-tg"
  target_groups             = var.target_groups
  vpc_id                    = var.vpc_id
  tags                      = var.tags
  target_group_depends_on   = aws_lb.application_no_logs
  target_groups_count       = var.target_groups_count
  create                    = var.create_alb && false == var.logging_enabled ? true : false
}

resource "aws_lb_listener" "frontend_http_tcp_no_logs" {
  load_balancer_arn = element(concat(aws_lb.application_no_logs.*.arn, [""]), 0)
  port              = var.http_tcp_listeners[count.index]["port"]
  protocol          = var.http_tcp_listeners[count.index]["protocol"]
  count             = var.create_alb && false == var.logging_enabled ? var.http_tcp_listeners_count : 0

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "EndPoint Not Valid"
      status_code  = "400"
    }
  }
}

module "frontend_http_tcp_no_logs_listener_rule" {
  source                    = "../terraform-aws-new-listener-rule"
  create                    = var.create_alb && false == var.logging_enabled ? true : false
  http_tcp_listeners_count  = var.http_tcp_listeners_count
  target_groups_count       = var.target_groups_count
  listener_arns             = slice(concat(aws_lb_listener.frontend_http_tcp_no_logs.*.arn, [""]), 0, var.http_tcp_listeners_count)
  target_group_arns         = module.tg_main_no_logs.target_group_arns
  target_groups             = var.target_groups
}


resource "aws_lb_listener" "frontend_https_no_logs" {
  load_balancer_arn = element(concat(aws_lb.application_no_logs.*.arn, [""]), 0)
  port              = var.https_listeners[count.index]["port"]
  protocol          = "HTTPS"
  certificate_arn   = var.https_listeners[count.index]["certificate_arn"]
  ssl_policy = lookup(
    var.https_listeners[count.index],
    "ssl_policy",
    var.listener_ssl_policy_default,
  )
  count = var.create_alb && false == var.logging_enabled ? var.https_listeners_count : 0

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "EndPoint Not Valid"
      status_code  = "400"
    }
  }
}

module "frontend_https_no_logs_listener_rule" {
  source                    = "../terraform-aws-new-listener-rule"
  create                    = var.create_alb && false == var.logging_enabled ? true : false
  https_listeners_count     = var.https_listeners_count
  target_groups_count       = var.target_groups_count
  listener_arns             = slice(concat(aws_lb_listener.frontend_https_no_logs.*.arn, [""]), 0, var.https_listeners_count)
  target_group_arns         = module.tg_main_no_logs.target_group_arns
  target_groups             = var.target_groups
}


resource "aws_lb_listener_certificate" "https_listener_no_logs" {
  listener_arn    = aws_lb_listener.frontend_https_no_logs[var.extra_ssl_certs[count.index]["https_listener_index"]].arn
  certificate_arn = var.extra_ssl_certs[count.index]["certificate_arn"]
  count           = var.create_alb && false == var.logging_enabled ? var.extra_ssl_certs_count : 0
}

