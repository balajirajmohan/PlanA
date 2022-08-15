data "aws_lb" "target_loadbalancer" {
  name  = var.loadbalancer_name
}

data "aws_ecs_cluster" "target_cluster" {
  cluster_name = format("%s-%s", var.common_name, var.common_suffix)
  count = var.create_in_existing_cluster == false ? 0 : 1
}

module "ecs-fargate-service" { 
  source                             = "git@github.com:nectar-uk/nectar-terraform-modules.git//terraform-aws-ecs-new-service"
  name_preffix                       = var.service_name == "" ? format("%s-%s", var.common_name, var.common_suffix) : format("%s-%s-%s", var.common_name, var.service_name, var.common_suffix)
  vpc_id                             = data.aws_vpc.vpc.id
  subnets                            = data.aws_subnet_ids.subnet_ids.ids
  ecs_cluster_name                   = var.common_name
  ecs_cluster_arn                    = var.create_in_existing_cluster == false ? aws_ecs_cluster.nectar_service_cluster[0].arn : data.aws_ecs_cluster.target_cluster[0].arn
  task_definition_arn                = module.ecs-fargate-task-definition.aws_ecs_task_definition_td_arn
  aws_lb_target_group_arn            = length(module.ecs-fargate-target-group.target_group_arns) == 0 ? "" : element(module.ecs-fargate-target-group.target_group_arns, 0) 
  self                               = var.ecs_sg_self
  security_groups                    = tolist(data.aws_lb.target_loadbalancer.security_groups)
  ecs_launch_type                    = var.ecs_launch_type
  container_name                     = var.container_name[0]
  container_port                     = module.ecs-fargate-task-definition.container_port
  container_healthcheck_port         = module.ecs-fargate-task-definition.container_healthcheck_port
  desired_count                      = var.desired_count
  platform_version                   = var.platform_version
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  propagate_tags                     = var.propagate_tags
  ordered_placement_strategy         = var.ordered_placement_strategy
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  placement_constraints              = var.placement_constraints_ecs_service
  service_registries                 = var.service_registries
  assign_public_ip                   = var.assign_public_ip
  common_tags                        = var.common_tags
  security_group_tags                = var.security_group_tags
  with_loadbalancer                  = length(module.ecs-fargate-target-group.target_group_arns) == 0 ? false : true
}