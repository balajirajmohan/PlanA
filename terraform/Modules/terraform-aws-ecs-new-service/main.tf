# ---------------------------------------------------------------------------------------------------------------------
# AWS SECURITY GROUP - ECS Tasks, allow traffic only from Load Balancer
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "ecs_tasks_sg" {
  name        = var.security_group_tags["Name"]
  description = format("%s %s Security Group", var.common_tags["environment"], var.security_group_tags["Name"])
  vpc_id      = var.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    self            = var.self
    security_groups = var.self == false ? var.security_groups : []
  }
  ingress {
    protocol        = "tcp"
    from_port       = var.container_healthcheck_port
    to_port         = var.container_healthcheck_port
    self            = var.self
    security_groups = var.self == false ? var.security_groups : []
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags         = merge(var.security_group_tags, var.common_tags)
  
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS SERVICE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "service_without_lb" {
  name                               = var.name_preffix
  cluster                            = var.ecs_cluster_arn
  task_definition                    = var.task_definition_arn
  launch_type                        = var.ecs_launch_type
  desired_count                      = var.desired_count
  platform_version                   = var.platform_version
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  propagate_tags                     = var.propagate_tags
  tags                               = var.common_tags
  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = ordered_placement_strategy.value.type
      field = lookup(ordered_placement_strategy.value, "field", null)
    }
  }
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }
  dynamic "service_registries" {
    for_each = var.service_registries
    content {
      registry_arn   = service_registries.value
      port           = lookup(service_registries, "port", null)
      container_name = lookup(service_registries, "container_name", null)
      container_port = lookup(service_registries, "container_port", null)
    }
  }
  network_configuration {
    security_groups  =[aws_security_group.ecs_tasks_sg.id]
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
  }
  count = var.with_loadbalancer == false ? 1 : 0
}

resource "aws_ecs_service" "service_with_lb" {
  name                               = var.name_preffix
  cluster                            = var.ecs_cluster_arn
  task_definition                    = var.task_definition_arn
  launch_type                        = var.ecs_launch_type
  desired_count                      = var.desired_count
  platform_version                   = var.platform_version
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  propagate_tags                     = var.propagate_tags
  tags                               = var.common_tags
  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = ordered_placement_strategy.value.type
      field = lookup(ordered_placement_strategy.value, "field", null)
    }
  }
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }
  dynamic "service_registries" {
    for_each = var.service_registries
    content {
      registry_arn   = service_registries.value
      port           = lookup(service_registries, "port", null)
      container_name = lookup(service_registries, "container_name", null)
      container_port = lookup(service_registries, "container_port", null)
    }
  }
  network_configuration {
    security_groups  =[aws_security_group.ecs_tasks_sg.id]
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
  }
  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  count = var.with_loadbalancer == true ? 1 : 0
}

/*

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Auto Scale Role
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "${var.name_preffix}-ecs-autoscale-role"
  assume_role_policy = file("${path.module}/files/iam/ecs_autoscale_iam_role.json")
}

resource "aws_iam_role_policy" "ecs_autoscale_role_policy" {
  name = "${var.name_preffix}-ecs-autoscale-role-policy"
  role = aws_iam_role.ecs_autoscale_role.id
  policy = file(
    "${path.module}/files/iam/ecs_autoscale_iam_role_policy.json",
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling - CloudWatch Alarm CPU High
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.name_preffix}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "85"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.service.name
  }
  alarm_actions = [aws_appautoscaling_policy.scale_up_policy.arn]
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling - CloudWatch Alarm CPU Low
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.name_preffix}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.service.name
  }
  alarm_actions = [aws_appautoscaling_policy.scale_down_policy.arn]
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Up Policy
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "scale_up_policy" {
  name               = "${var.name_preffix}-scale-up-policy"
  depends_on         = [aws_appautoscaling_target.scale_target]
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Down Policy
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "scale_down_policy" {
  name               = "${var.name_preffix}-scale-down-policy"
  depends_on         = [aws_appautoscaling_target.scale_target]
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Target
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_appautoscaling_target" "scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = aws_iam_role.ecs_autoscale_role.arn
  min_capacity       = 1
  max_capacity       = 5
}

*/
