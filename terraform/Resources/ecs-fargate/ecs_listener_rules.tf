
data "aws_lb_listener" "targetlistener" {
  load_balancer_arn = data.aws_lb.target_loadbalancer.arn
  port              = var.loadbalancer_port
}

module "ecs-fargate-listener-rule" {
    source                   = "git@github.com:nectar-uk/nectar-terraform-modules.git//terraform-aws-new-listener-rule" 
    http_tcp_listeners_count = var.http_listeners_count
    https_listeners_count = var.https_listeners_count
    target_groups_count   = length(var.target_groups)
    listener_arns         = [data.aws_lb_listener.targetlistener.arn]
    target_group_arns     = module.ecs-fargate-target-group.target_group_arns
    target_groups         = var.target_groups
    priority              = var.priority
    listener_rule_depends_on     = [module.ecs-fargate-target-group.target_group_arns]
    create                = var.create_listener_rule
}
