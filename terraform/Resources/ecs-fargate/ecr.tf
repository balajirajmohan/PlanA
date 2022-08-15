resource "aws_ecr_repository" "repository" {
  name                 = var.ecreponame  # "repository"
  image_tag_mutability = "MUTABLE"
}