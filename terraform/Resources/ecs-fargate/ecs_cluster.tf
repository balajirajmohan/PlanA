resource "aws_ecs_cluster" "nectar_service_cluster" {
  name = format("%s-%s", var.common_name, var.common_suffix) 
  tags = merge(var.cluster_tags, var.common_tags)
  setting {
    name = "containerInsights"
    value = var.container_insight
  }
  count = var.create_in_existing_cluster == false ? 1 : 0
}
