variable "http_tcp_listeners_count" {
  description = "A manually provided count/length of the http_tcp_listeners list of maps since the list cannot be computed."
  type        = number
  default     = 0
}

variable "https_listeners_count" {
  description = "A manually provided count/length of the https_listeners list of maps since the list cannot be computed."
  type        = number
  default     = 0
}

variable "create" {
  description = "whether to create the target group, for allowing other modules calling this module to control execution"
  type = bool
  default = true
}

variable "target_groups_count" {
  description = "A manually provided count/length of the target_groups list of maps since the list cannot be computed."
  type        = number
  default     = 0
}

variable "listener_arns" {
  type = list
  description = "the listener details list to add the listener rule to"
  default = []
}

variable "target_group_arns" {
  type = list
  description = "the listener details list to add the listener rule to"
  default = []
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port. Optional key/values are in the target_groups_defaults variable."
  type        = list(map(string))
  default     = []
}

variable "priority" {
  type = number
  description = "the rule priority for the listener rule"
  default = 0
}

variable "listener_rule_depends_on" {
  description = "depends on for resource creation dependency"
  type = any
  default = []
}
