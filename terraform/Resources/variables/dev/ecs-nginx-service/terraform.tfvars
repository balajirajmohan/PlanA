# Variables for common.tfvars file, for selection of VPC and subnets
vpc_name                      = "<Pre-existing-VPC>"
subnet_filter                 = "*private_1*"

#The Preffix name for all the resources created as part of the terraform script
common_name                  = "PlanA-Resources"

# The suffix to be added at end of all resources created as part of the terraform script
common_suffix                = "dev"




# Tags to be added specifically to the ECS cluster
cluster_tags = {
  "description"              = "PlanA fargate based ECS Cluster" 
  "type"                     = "ECS-CLUSTER"
  "Application"              = "PlanA-Demo"
}

# Tags to be added specifically to the ECS service security group
security_group_tags = {
  "Name"                    = "sg_ecs_dev_PlanADemo"
}

# The launch type to be used for the ECS cluster, This deployment model only supports FARGATE as an entry.
ecs_launch_type = "FARGATE"

# Whether to enable container insights for the cluster, provide value as enabled to enable the insight.
container_insight = "disabled"

# Provide the Following value to append extra value in the respective service name, the format is common_name-service_name-service
#service_name                  = "offer-clicks-consumer"

# Provide the Following value to append extra value in the respective taskdef name, the format is common_name-task_definition_name-td
#task_definition_name          = "offer-clicks-consumer"





#provide the port mappings for each container as part of the task definition.
#port_mappings = [[{},{},....],[],....]

#Provide the comma seperated list of image names, each value corresponds to a container-definition as part of the task-definition
container_image = ["nginx:latest"]

#Provide the comma seperated list of container names, each value corresponds to a container-definition as part of the task-definition
container_name = ["nginx-1","nginx-2"]


# The command that is passed to the container.This is a list of list of strings type for each container in the task.
# command = [[],[],....]

#Provide the comma seperated list of container cpu for each container as part of the task definition.
container_cpu = [0,0]

# The list of list of dependencies defined for each container startup and shutdown. A container can contain multiple dependencies. When a dependency is defined for container startup, for container shutdown it is reversed. The format is [[{container1-dependency1},{container1-dependency2}...],[{container2-dependency1},{container2-dependency2}...]...]
# container_depends_on = [[],[],....]

#Provide the comma seperated list of container memory reservations, each value corresponds to a container-definition as part of the task-definition
container_memory_reservation = [0,0]

#Provide the comma seperated list of container memory hard limit which needs to be equal or higher than the respective reservation, each value corresponds to a container-definition as part of the task-definition
container_memory = [0,0]

#The list of dns servers to be used by each container in the task
#dns_servers = [[],[],[],.....]

# The list of list of entry point that is passed to each container
# entrypoint = [[],[],....]

# provide the list of environment variables for each of the container as part of the task definition.
# environment = [[{},{},{},....],[],....]


]

# Provide comma separated list of whether corresponding container is essential or not, acceptable values are true and false.
essential = ["true", "false"]

# A list of map containing command (string), interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy, and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries)
# healthcheck = [{},{},....]

# List of List of container names this container can communicate with without port mappings.
# links = [[],[],....]

# Container mount points. This is a list of list of maps, where each map should contain a `containerPath` and `sourceVolume`
# mount_points = [[{},{},....],[],....]

# This list Determines whether each container is given read-only access to its root filesystem. Due to how Terraform type casts booleans in json it is required to double quote this value
# readonly_root_filesystem = ["false"]

# Container repository credentials; required when using a private repo.  This list of map currently supports a single key; \"credentialsParameter\", which should be the ARN of a Secrets Manager's secret holding the credentials
# repository_credentials = [{},{},....]

# The secrets to pass to the container. This is a list of list of maps for each container in the task definition.
# secrets = [[{},{},....],[],....]

]

# List of Timeout in seconds between sending SIGTERM and SIGKILL to each container in the task definition.
# stop_timeout = [30]

# Container ulimit settings. This is a list of list of maps, where each map should contain \"name\", \"hardLimit\" and \"softLimit\"
# ulimits = [[{},{},....],[],....]

# The list of user to run as inside the container. Can be any of these formats: user, user:group, uid, uid:gid, user:gid, uid:group.The format is [\"usercontainer1\",\"usercontainer2\"....]
# user = ["",""]

#A list of list of VolumesFrom maps which contain \"sourceContainer\" (name of the container that has the volumes to mount) and \"readOnly\" (whether the container can write to the volume).
#volumes_from = [[{},{},....],[],....]
volumes_from = [[
  {
    sourceContainer = "glowroot"
    readOnly = false
  }
],
[]]

# The working directory to run commands inside the container.This is a list of strings for each container in the task.
# working_directory = ["",""....]





# Whether to create the ECS service security group with self mode enabled.acceptable values are true and false.
ecs_sg_self = false

# The security groups to be added as source for the ingress rules for service security group. If not specified the security group of the loadbalancer will be added as source.
# ecs_sg_security_groups = []

#Provide the desired count for the no. of instances of task to run.
desired_count = 0

# The service discovery registries for the service. The maximum number of service_registries blocks is 1. This is a map that should contain the following fields "registry_arn", "port", "container_port" and "container_name"
# service_registries = {}

# Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false. Default false.
# assign_public_ip = false

# Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered_placement_strategy blocks is 5. This is a list of maps where each map should contain "id" and "field"
# ordered_placement_strategy = [{},{},....]

# Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers.
# health_check_grace_period_seconds = 0

# rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. This is a list of maps, where each map should contain "type" and "expression"
# placement_constraints_ecs_service = [{},{},....]

# The platform version on which to run your service. Defaults to LATEST. More information about Fargate platform versions can be found in the AWS ECS User Guide.
# platform_version = "LATEST"

# The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment.
# deployment_maximum_percent = 200

# The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment.
# deployment_minimum_healthy_percent = 100

# Specifies whether to enable Amazon ECS managed tags for the tasks within the service.
# default = false

# Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION. Default to SERVICE
# propagate_tags = "SERVICE"





# A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. This is a list of maps, where each map should contain \"type\" and \"expression\""
# placement_constraints = [{},{},{}....]

# The proxy configuration details for the App Mesh proxy. This is a list of maps, where each map should contain \"container_name\", \"properties\" and \"type\""
# proxy_configuration = [{},{},{}....]

# arn of the role to be added as the task execution role to the task definition
ecs_task_execution_role_arn   = "arn:aws:iam::887536910004:role/ecsTaskExecutionRole"

# Provide the cpu limit for the task, it cannot be less than the sum of the container_cpu list.
total_cpu = 2048

# Provide the memory limit for the task, it cannot be less than the sum of the memory reservation list.
total_memory = 4096



# Provide the Following value as true to create the listener rule
create_listener_rule = false

# list of map of target groups to be created.
# target_group = [{},{},{}....]

# Provide the name of the target group to attach the listener rule to and allow traffic from this load-balancer to the ECS cluster.
loadbalancer_name = "<UpdatemyNameHere>"

# provide the port number to select the listener to which the rule needs to be added.
loadbalancer_port = 80

# No. of http listeners to ass rule to.
# https_listeners_count = 0

# No. of http listeners to ass rule to.
# http_listeners_count = 1

# Provide this value to assign a particular priority to the listener rule, if not defined or 0 next available priority is assigned to the rule.
# priority = 0
