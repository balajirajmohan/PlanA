vpc_name                      = "vpc_ew2_dev_01"
subnet_filter                 = "*private_1*"

# only alphanumeric characters and hyphens allowed
alb_name = "alb-ew2-dev-onenectar"
enable_cross_zone_load_balancing = true
alb_is_internal = true
logging_enabled = true
log_bucket_name = "nectar-alb-logs"
log_location_prefix = "dev"

target_groups = [
    {
        name               = "tg-ew2-dev-nectar-transactions",
        backend_protocol   = "HTTP",
        backend_port       = "8080",
        target_type        = "ip",
        health_check_path  = "/health",
        health_check_port  = "8081",
        path_prefix        = "/nectar-transactions/*"
    },
    {
        name               = "tg-ew2-dev-nectar-enrolments",
        backend_protocol   = "HTTP",
        backend_port       = "8080",
        target_type        = "ip",
        health_check_path  = "/health",
        health_check_port  = "8081",
        path_prefix        = "/nectar-enrolments/*"
    }
]

 http_tcp_listeners = [
    {
        port               = "80"
        protocol           = "HTTP"
    }
]

zone_id                    = "ZAX1KMKUWI6I5"
dns_name                   = "1nectar.dev.nllservices.com"

tags = {
  "duration"                 = "Persistent"
  "costcentre"               = "N8460"
  "customer"                 = "OneNectar Dev Team"
  "environment"              = "OneNectar_Dev"
  "account"                  = "nectar-loyalty-dev"
  "project"                  = "One Nectar"
  "service-owner"            = "Ben Trisk"
  "service-owner-email"      = "Ben.Trisk@nectarloyalty.co.uk"
  "technical-contact"        = "Dineshkumar Muthusamy"
  "technical-contact-email"  = "Dineshkumar.M@nectarloyalty.co.uk"
  "operational-hours"        = "9x5"
  "backup"                   = "None"
  "backup-retention"         = "N/A"
  "live"                     = "Yes"
  "description"              = "Nectar fargate based MSAs Application Load balancer" 
  "type"                     = "ALB"
}

sg_rules = [
  {
    "type"        = "ingress"
    "source"      = "172.21.19.0/25,172.21.19.128/25"
    "description" = "HTTP Access from AWS Workspace"
    "from_port"   = "80"
    "to_port"     = "80"
    "protocol"    = "tcp"
  },
  {
    "type"        = "egress"
    "source"      = "0.0.0.0/0"
    "description" = "Allow all access"
    "from_port"   = "-1"
    "to_port"     = "-1"
    "protocol"    = "-1"
  }
]

security_group_tags = {
  "Name" = "sg_alb_dev_onenectar"
}