# Environment variables are composed into the container definition at output generation time. See outputs.tf for more information.
# locals {

#   container_definition = {
#     name                   = var.container_name
#     image                  = var.container_image
#     memory                 = "memory_sentinel_value"
#     memoryReservation      = "memory_reservation_sentinel_value"
#     cpu                    = "cpu_sentinel_value"
#     essential              = var.essential
#     entryPoint             = var.entrypoint
#     command                = var.command
#     workingDirectory       = var.working_directory
#     readonlyRootFilesystem = var.readonly_root_filesystem
#     mountPoints            = var.mount_points
#     dnsServers             = var.dns_servers
#     ulimits                = var.ulimits
#     repositoryCredentials  = var.repository_credentials
#     links                  = var.links
#     volumesFrom            = var.volumes_from
#     user                   = var.user
#     dependsOn              = var.container_depends_on
#     stopTimeout            = "stop_timeout_sentinel_value"

#     portMappings = var.port_mappings

#     healthCheck = var.healthcheck

#     logConfiguration = {
#       logDriver = var.log_driver
#       options   = var.log_options
#     }

#     environment = "environment_sentinel_value"
#     secrets     = "secrets_sentinel_value"
#   }

#   environment = var.environment
#   secrets     = var.secrets
# }

resource "null_resource" "test" {
  count = length(var.container_name)

  triggers = {
    name                   = element(var.container_name, count.index)
    image                  = (length(var.container_image) - 1) >= count.index ? element(var.container_image, count.index) : "null"
    memory                 = (length(var.container_memory) - 1) >= count.index ? (element(var.container_memory, count.index) == 0 ? "null" : element(var.container_memory, count.index)) : "null"
    memoryReservation      = (length(var.container_memory_reservation) - 1) >= count.index ? (element(var.container_memory_reservation, count.index) == 0 ? "null" : element(var.container_memory_reservation, count.index)) : "null"
    cpu                    = (length(var.container_cpu) - 1) >= count.index ? element(var.container_cpu, count.index) : "null"
    essential              = (length(var.essential) - 1) >= count.index ? element(var.essential, count.index) : "null"
    entryPoint             = (length(var.entrypoint) - 1) >= count.index ? jsonencode(element(var.entrypoint, count.index)) : "null"
    command                = (length(var.command) - 1) >= count.index ? jsonencode(element(var.command, count.index))  : "null"
    workingDirectory       = (length(var.working_directory) - 1) >= count.index ? element(var.working_directory, count.index)  : "null"
    readonlyRootFilesystem = (length(var.readonly_root_filesystem) - 1) >= count.index ? element(var.readonly_root_filesystem, count.index)  : "null"
    mountPoints            = (length(var.mount_points) - 1) >= count.index ? jsonencode(element(var.mount_points, count.index))  : "[]"
    dnsServers             = (length(var.dns_servers) - 1) >= count.index ? jsonencode(element(var.dns_servers, count.index))  : "null"
    ulimits                = (length(var.ulimits) - 1) >= count.index ? jsonencode(element(var.ulimits, count.index))  : "null"
    repositoryCredentials  = (length(var.repository_credentials) - 1) >= count.index ? jsonencode(element(var.repository_credentials, count.index))  : "null"
    links                  = (length(var.links) - 1) >= count.index ? jsonencode(element(var.links, count.index))  : "null"
    volumesFrom            = (length(var.volumes_from) - 1) >= count.index ? jsonencode(element(var.volumes_from, count.index))  : "[]"
    user                   = (length(var.user) - 1) >= count.index ? element(var.user, count.index)  : "null"
    dependsOn              = (length(var.container_depends_on) - 1) >= count.index ? jsonencode(element(var.container_depends_on, count.index))  : "null"
    stopTimeout            = (length(var.stop_timeout) - 1) >= count.index ? element(var.stop_timeout, count.index)  : "null"

    portMappings = (length(var.port_mappings) - 1) >= count.index ? jsonencode(element(var.port_mappings, count.index)) : "[]"

    healthCheck = (length(var.healthcheck) - 1) >= count.index ? jsonencode(element(var.healthcheck, count.index)) : "null"

    logConfiguration = jsonencode({
      logDriver = var.log_driver
      options   = var.log_options
    })
    environment = (length(var.environment) - 1) >= count.index ? jsonencode(element(var.environment, count.index)) : "[]"
    secrets     = (length(var.secrets) - 1) >= count.index ? jsonencode(element(var.secrets, count.index)) : "null"
  }
}
