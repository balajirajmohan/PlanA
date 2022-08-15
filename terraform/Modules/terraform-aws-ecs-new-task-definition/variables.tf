# ---------------------------------------------------------------------------------------------------------------------
# Misc
# ---------------------------------------------------------------------------------------------------------------------
variable "name_preffix" {
  description = "Name preffix for resources on AWS"
}

variable "common_tags" {
  description = "A mapping of tags to assign to the resources"
  default     = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Container Definition Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "container_image" {
  type        = list
  description = "The list of image used to start the container. Images in the Docker Hub registry available by default"
  default = []
}

variable "container_name" {
  type        = list
  description = "List of names of the container as part of single task definition. The Format is like [\"container-name-1\",\"container-name-2\"]Up to 255 characters ([a-z], [A-Z], [0-9], -, _ allowed)"
  default = []
}


locals {
  log_driver = "awslogs"
  log_options = {
    "awslogs-region"        = "eu-west-2"
    "awslogs-group"         = format("/ecs/service/%s", var.name_preffix)
    "awslogs-stream-prefix" = "ecs"
  }
}



variable "port_mappings" {
  type        = list
  description = "The port mappings to configure for the container. This is a list of list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"

  default = [[{
    "containerPort" = 80
    "hostPort"      = 80
    "protocol"      = "tcp"
  }]]
}


# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Task Definition Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "placement_constraints" {
  type        = list
  description = "(Optional) A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. This is a list of maps, where each map should contain \"type\" and \"expression\""
  default     = []
}

variable "proxy_configuration" {
  type        = list
  description = "(Optional) The proxy configuration details for the App Mesh proxy. This is a list of maps, where each map should contain \"container_name\", \"properties\" and \"type\""
  default     = []
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "AWS task execution role arn"
}

variable "total_cpu" {
  type        = number
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = 1024
}

variable "total_memory" {
  type        = number
  description = "The number of memory units to reserve for the container."
  default     = 8192
}
# ---------------------------------------------------------------------------------------------------------------------
# AWS CLOUDWATCH LOG GROUP
# ---------------------------------------------------------------------------------------------------------------------

variable "log_group_retention_in_days" {
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Default to 30 days"
  type        = number
  default     = 30
}

variable "log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  default     = ""
}