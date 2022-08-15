variable "container_name" {
  type        = list
  description = "List of name/names of the container as part of single task definition. The Format is like [\"container-name-1\",\"container-name-2\"]Up to 255 characters ([a-z], [A-Z], [0-9], -, _ allowed)"
  default = []
}

variable "container_image" {
  type        = list
  description = "The list of image used to start the container. Images in the Docker Hub registry available by default"
  default = []
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



variable "log_driver" {
  type        = string
  description = "The log driver to use for the container. If using Fargate launch type, only supported value is awslogs"
  default     = "awslogs"
}

variable "log_options" {
  type        = map
  description = "The configuration options to send to the `log_driver`.This is a map"
  default = {
    "awslogs-region"        = "eu-west-2"
    "awslogs-group"         = "/ecs/service/ecscontainer"
    "awslogs-stream-prefix" = "ecs"
  }
}

