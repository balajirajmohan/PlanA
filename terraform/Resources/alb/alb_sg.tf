data "aws_security_group" "sgid" {
  count = length(var.sg_rules_with_sgid)
  name = lookup(var.sg_rules_with_sgid[count.index], "source")
}

# Security Greoup for the ALB
resource "aws_security_group" "alb_sg" {
  name         = var.security_group_tags["Name"]
  description  = format("%s %s Security Group", var.tags["environment"], var.tags["type"])
  vpc_id       = data.aws_vpc.vpc.id
  tags         = merge(var.security_group_tags, var.tags)
}

resource "aws_security_group_rule" "ingress_rules" {
  count              = length(var.sg_rules)
  security_group_id  = aws_security_group.alb_sg.id
  type               = lookup(var.sg_rules[count.index], "type")
  cidr_blocks        = split(",", lookup(var.sg_rules[count.index], "source"))
  description        = lookup(var.sg_rules[count.index], "description")
  from_port          = lookup(var.sg_rules[count.index], "from_port")
  to_port            = lookup(var.sg_rules[count.index], "to_port")
  protocol           = lookup(var.sg_rules[count.index], "protocol")
}

resource "aws_security_group_rule" "ingress_rules_with_sgid" {
  count                           = length(var.sg_rules_with_sgid)
  security_group_id               = aws_security_group.alb_sg.id
  type                            = lookup(var.sg_rules_with_sgid[count.index], "type")
  source_security_group_id        = element(data.aws_security_group.sgid.*.id, count.index)
  description                     = lookup(var.sg_rules_with_sgid[count.index], "description")
  from_port                       = lookup(var.sg_rules_with_sgid[count.index], "from_port")
  to_port                         = lookup(var.sg_rules_with_sgid[count.index], "to_port")
  protocol                        = lookup(var.sg_rules_with_sgid[count.index], "protocol")
}
