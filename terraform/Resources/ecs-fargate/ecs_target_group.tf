module "ecs-fargate-target-group" { 
  source                             = "git@github.com:nectar-uk/nectar-terraform-modules.git//terraform-aws-new-tg"
  target_groups                      = var.target_groups
  target_groups_count                = length(var.target_groups)
  vpc_id                             = data.aws_vpc.vpc.id
  tags                               = var.common_tags
}
