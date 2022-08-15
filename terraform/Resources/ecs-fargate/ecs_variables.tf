variable "common_name" {
  description = "Common Name for resources on AWS"
}

variable "common_suffix" {
  description = "Name added at the end of each resource on AWS"
  default     = "dev"
}


variable "common_tags" {
  description = "A mapping of tags to assign to the resources"
  default     = {}
}

variable "cluster_tags" {
  description = "A mapping of tags to assign to the cluster"
  default     = {}
}

variable "security_group_tags" {
  description = "A mapping of tags to assign to the cluster sg"
  default     = {}
}

variable "ecs_launch_type" {
  description = "ECS Launch type EC2 or Fargate as required Compatibilities"
  type        = string
  default     = "FARGATE"
}

variable "container_insight" {
  description = "whether to enable container insights for the ECS cluster"
  default = "enabled"
}

#### Provide the Following value to append extra value in the respective service name ####
variable "service_name" {
  description = "additional name to be appended after the common name"
  default = ""
}

#### Provide the Following value to append extra value in the respective task def name ####
variable "task_definition_name" {
  description = "additional name to be appended after the common name"
  default = ""
}

#### Provide the Following value to create the ecs service in already existing cluster ####
variable "create_in_existing_cluster" {
  type = bool
  description = "provide value as true or false to whether create service in an existing cluster with the name in the variable common_name"
  default = false
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Container Definition Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "port_mappings" {
  type        = list
  description = "The port mappings to configure for the container. This is a list of list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"

  default = [[{
    "containerPort" = 80
    "hostPort"      = 80
    "protocol"      = "tcp"
  }]]
}

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

variable "command" {
  type        = list
  description = "(Optional) The command that is passed to the container.This is a list of list of strings type."
  default     = [[]]
}

variable "container_cpu" {
  type        = list
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
  description = "(Optional) The list of number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = [512] # 1 vCPU 
}

variable "container_depends_on" {
  type        = list
  description = "(Optional) The list of list of dependencies defined for each container startup and shutdown. A container can contain multiple dependencies. When a dependency is defined for container startup, for container shutdown it is reversed. The format is [[{container1-dependency1},{container1-dependency2}...],[{container2-dependency1},{container2-dependency2}...]...]"
  default     = [[]]
}

variable "container_memory" {
  type        = list
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
  description = "(Optional) The list of amount of memory (in MiB) to allow the container to use. This is a hard limit, if the container attempts to exceed the container_memory, the container is killed. This field is optional for Fargate launch type and the total amount of container_memory of all containers in a task will need to be lower than the task memory value"
  default     = [8192] # 8 GB
}

variable "container_memory_reservation" {
  type        = list
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
  description = "(Optional) The list of amount of memory (in MiB) to reserve for the container. If container needs to exceed this threshold, it can do so up to the set container_memory hard limit"
  default     = [2048] # 2 GB
}

variable "dns_servers" {
  type        = list
  description = "(Optional) The list of list of Container DNS servers for each container. This is a list of strings specifying the IP addresses of the DNS servers."
  default     = [[]]
}

variable "entrypoint" {
  type        = list
  description = "(Optional) The list of list of entry point that is passed to each container"
  default     = [[]]
}

variable "environment" {
  type        = list
  description = "(Optional) The environment variables to pass to the container. This is a list of list of maps. Each map should contain `name` and `value`"
  default     = [[]]
}

variable "essential" {
  type        = list
  description = "(Optional) this list Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = ["true"]
}

variable "healthcheck" {
  type        = list
  description = "(Optional) A list of map containing command (string), interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy, and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries)"
  default     = [{}]
}

variable "links" {
  type        = list
  description = "(Optional) List of List of container names this container can communicate with without port mappings."
  default     = [[]]
}

variable "mount_points" {
  type        = list
  description = "(Optional) Container mount points. This is a list of list of maps, where each map should contain a `containerPath` and `sourceVolume`"
  default     = [[]]
}

variable "readonly_root_filesystem" {
  type        = list
  description = "(Optional) This list Determines whether each container is given read-only access to its root filesystem. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = ["false"]
}

variable "repository_credentials" {
  type        = list
  description = "(Optional) Container repository credentials; required when using a private repo.  This list of map currently supports a single key; \"credentialsParameter\", which should be the ARN of a Secrets Manager's secret holding the credentials"
  default     = [{}]
}

variable "secrets" {
  type        = list
  description = "(Optional) The secrets to pass to the container. This is a list of list of maps"
  default     = [[]]
}

variable "stop_timeout" {
  type        = list
  description = "(Optional) List of Timeout in seconds between sending SIGTERM and SIGKILL to container"
  default     = [30]
}

variable "ulimits" {
  type        = list
  description = "(Optional) Container ulimit settings. This is a list of list of maps, where each map should contain \"name\", \"hardLimit\" and \"softLimit\""
  default     = [[]]
}

variable "user" {
  type        = list
  description = "(Optional) The list of user to run as inside the container. Can be any of these formats: user, user:group, uid, uid:gid, user:gid, uid:group.The format is [\"usercontainer1\",\"usercontainer2\"....]"
  default     = [""]
}

variable "volumes_from" {
  type        = list
  description = "(Optional) A list of list of VolumesFrom maps which contain \"sourceContainer\" (name of the container that has the volumes to mount) and \"readOnly\" (whether the container can write to the volume)."
  default     = [[]]
}

variable "working_directory" {
  type        = list
  description = "(Optional) The working directory to run commands inside the container.This is a list of strings"
  default     = [""]
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Service Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "ecs_sg_self" {
  description = "(Optional) The security groups associated with the task or service. If you do not specify a security group, the default security group for the VPC is used."
  type        = bool
  default     = true
}

variable "ecs_sg_security_groups" {
  description = "(Optional) The security groups associated with the task or service. If you do not specify a security group, the default security group for the VPC is used."
  type        = list
  default     = []
}

variable "desired_count" {
  description = "(Optional) The number of instances of the task definition to place and keep running. Defaults to 1."
  type        = number
  default     = 1
}

variable "service_registries" {
  description = "(Optional) The service discovery registries for the service. The maximum number of service_registries blocks is 1. This is a map that should contain the following fields \"registry_arn\", \"port\", \"container_port\" and \"container_name\""
  type        = map
  default     = {}
}


variable "assign_public_ip" {
  description = "(Optional) Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false. Default false."
  type        = bool
  default     = false
}

variable "ordered_placement_strategy" {
  description = "(Optional) Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered_placement_strategy blocks is 5. This is a list of maps where each map should contain \"id\" and \"field\""
  type        = list
  default     = []
}

variable "health_check_grace_period_seconds" {
  description = "(Optional) Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
  type        = number
  default     = 0
}

variable "placement_constraints_ecs_service" {
  type        = list
  description = "(Optional) rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. This is a list of maps, where each map should contain \"type\" and \"expression\""
  default     = []
}


variable "platform_version" {
  description = "(Optional) The platform version on which to run your service. Defaults to LATEST. More information about Fargate platform versions can be found in the AWS ECS User Guide."
  default     = "LATEST"
}

variable "deployment_maximum_percent" {
  description = "(Optional) The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "(Optional) The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  type        = number
  default     = 100
}


variable "enable_ecs_managed_tags" {
  description = "(Optional) Specifies whether to enable Amazon ECS managed tags for the tasks within the service."
  default     = false
}

variable "propagate_tags" {
  description = "(Optional) Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION. Default to SERVICE"
  default     = "SERVICE"
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
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = 8192
}



# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Target Group Variables
# ---------------------------------------------------------------------------------------------------------------------
#### Provide the Following value as true to create the listener rule
variable "create_listener_rule" {
  type = bool
  description = "provide value as true or false to whether create listener rule in an existing load balancer"
  default = true
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port. Optional key/values are in the target_groups_defaults variable."
  type        = list(map(string))
  default     = []
}

variable "loadbalancer_name" {
  description = "loadbalancer name to add this target group to"
  default = ""
}

variable "loadbalancer_port" {
  type = number
  description = "loadbalancer port for which the target will be added to respective listener"
  default = 80
}

variable "https_listeners_count" {
  type = number
  description = "No. of https listeners"
  default = 0
}

variable "http_listeners_count" {
  type = number
  description = "No. of http listeners"
  default = 0
}

variable "priority" {
  type = number
  description = "the rule priority for the listener rule"
  default = 0
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECR Repo Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "ecreponame" {
  type = string
  description = "ecr repo name"
  default = ""
}