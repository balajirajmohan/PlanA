locals {
  lb_sg = tolist(data.aws_lb.target_loadbalancer.security_groups)
}

resource "aws_security_group_rule" "ecs_sg_lb_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.ecs-fargate-service.aws_security_group_ecs_tasks_sg_id
  security_group_id = local.lb_sg[0]
  description = format("HTTP Access from %s-%s", var.common_name, var.common_suffix)
  count = length(local.lb_sg) == 0 ? 0 : (var.create_listener_rule == true ? 1 : 0)
}