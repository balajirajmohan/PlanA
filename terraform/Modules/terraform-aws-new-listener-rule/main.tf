resource "aws_lb_listener_rule" "frontend_http_tcp_no_logs_listener_rule" {
  count        = var.create == true ? var.http_tcp_listeners_count * var.target_groups_count : 0
  listener_arn = var.listener_arns[count.index % var.http_tcp_listeners_count]
  priority     = var.priority != 0 ? var.priority : null

  action {
    type             = "forward"
    target_group_arn = var.target_group_arns[count.index / var.http_tcp_listeners_count]
  }

  condition {
    field  = "path-pattern"
    values = split(",", lookup(
      var.target_groups[count.index / var.http_tcp_listeners_count],
      "path_prefix")
    )
  }
  depends_on = [var.listener_rule_depends_on]
}

resource "aws_lb_listener_rule" "frontend_https_no_logs_listener_rule" {
  count      = var.create == true ? var.https_listeners_count * var.target_groups_count : 0
  listener_arn = var.listener_arns[count.index % var.https_listeners_count]
  priority     = var.priority != 0 ? var.priority : null

  action {
    type             = "forward"
    target_group_arn = var.target_group_arns[count.index / var.https_listeners_count]
  }

  condition {
    field  = "path-pattern"
    values = split(",", lookup(
      var.target_groups[count.index / var.https_listeners_count],
      "path_prefix")
    )
  }
  depends_on = [var.listener_rule_depends_on]
}