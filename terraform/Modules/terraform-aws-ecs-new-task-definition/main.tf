
# ---------------------------------------------------------------------------------------------------------------------
# AWS CLOUDWATCH LOG GROUP
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "log_group" {
  name              = local.log_options["awslogs-group"]
  retention_in_days = var.log_group_retention_in_days
  kms_key_id        = var.log_group_kms_key_id
  tags              = var.common_tags
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS CLOUDWATCH LOG STREAM
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = local.log_options["awslogs-group"]
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Task Definition
# ---------------------------------------------------------------------------------------------------------------------
# Container Definition
module "container_definition" {
  source  = "../terraform-aws-ecs-new-container-definition"
  container_image              = var.container_image
  container_name               = var.container_name
  command                      = var.command
  log_driver                   = local.log_driver
  log_options                  = local.log_options
  port_mappings                = var.port_mappings
}

locals {
  portmapping = element(var.port_mappings, 0)
  }
  
resource "null_resource" "port" {
  triggers = {
    containerport = (length(local.portmapping) - 1) >= 0 ? lookup(element(local.portmapping, 0), "containerPort") : 8080
    healthcheckport = (length(local.portmapping) - 1) >= 0 ? lookup(element(local.portmapping, (length(local.portmapping) - 1)), "containerPort") : 8081
    }
  }
  
# Task Definition
resource "aws_ecs_task_definition" "td" {
  family                = var.name_preffix
  container_definitions = module.container_definition.json_map
  task_role_arn         = var.ecs_task_execution_role_arn
  execution_role_arn    = var.ecs_task_execution_role_arn
  network_mode          = "awsvpc"
  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }
  cpu                      = var.total_cpu
  memory                   = var.total_memory
  requires_compatibilities = ["FARGATE"]
  dynamic "proxy_configuration" {
    for_each = var.proxy_configuration
    content {
      container_name = proxy_configuration.value.container_name
      properties     = lookup(proxy_configuration.value, "properties", null)
      type           = lookup(proxy_configuration.value, "type", null)
    }
  }
}

