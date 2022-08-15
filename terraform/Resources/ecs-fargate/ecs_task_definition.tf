module "ecs-fargate-task-definition" {
  source                       = "../../Modules/-aws-ecs-new-task-definition"
  name_preffix                 = var.task_definition_name == "" ? format("%s-%s", var.common_name, var.common_suffix) : format("%s-%s-%s", var.common_name, var.task_definition_name, var.common_suffix)
  ecs_task_execution_role_arn  = var.ecs_task_execution_role_arn

  container_name               = var.container_name
  container_image              = var.container_image
  port_mappings                = var.port_mappings
}
