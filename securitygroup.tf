# resource "aws_security_group" "websg" {
#   name        = "websg"
#   description = "This is web security group"
#   vpc_id      = aws_vpc.ntier_vpc.id

#   #we commented as sir didnt use tags so
#   # tags = {
#   #   Name = "websg"  
#   # }

#   depends_on = [
#     aws_vpc.ntier_vpc
#   ]

# }

resource "aws_security_group" "websg" {
  name        = var.websg_config.name
  description = var.websg_config.description
  vpc_id      = aws_vpc.ntier_vpc.id

  depends_on = [
    aws_vpc.ntier_vpc
  ]

}


# resource "aws_security_group_rule" "websg_http" {
#   type              = "ingress"
#   protocol          = "tcp"
#   security_group_id = aws_security_group.websg.id
#   cidr_blocks       = ["0.0.0.0/0"] # the list of cidr_blocks here so we used [] and 0.0.0.0/0 which means from anywhere
#   #cidr_blocks = aws_vpc.ntier_vpc.cidr_block this is documentation example process
#   to_port   = 80
#   from_port = 80
#   # (here we are opening only one port so given to_port = 80 and from_port=80..if you want to open
#   # from 80 to 8000 then have to give from_port=80 and to_port=8000)

#   depends_on = [
#     aws_security_group.websg
#   ]
# }

resource "aws_security_group_rule" "websg_rules" {
  count             = length(var.websg_config.rules)
  type              = var.websg_config.rules[count.index].type
  protocol          = var.websg_config.rules[count.index].protocol
  security_group_id = aws_security_group.websg.id
  cidr_blocks       = [var.websg_config.rules[count.index].cidr_block]
  to_port           = var.websg_config.rules[count.index].to_port
  from_port         = var.websg_config.rules[count.index].from_port

  depends_on = [
    aws_security_group.websg
  ]
}

# resource "aws_security_group_rule" "websg_ssh" {
#   type              = "ingress"
#   protocol          = "tcp"
#   security_group_id = aws_security_group.websg.id
#   cidr_blocks       = ["0.0.0.0/0"]
#   to_port           = 22
#   from_port         = 22

#   depends_on = [
#     aws_security_group.websg
#   ]

# }

# resource "aws_security_group_rule" "websg_out" {
#   type              = "egress"
#   protocol          = "-1"
#   security_group_id = aws_security_group.websg.id
#   cidr_blocks       = ["0.0.0.0/0"]
#   to_port           = 65535
#   from_port         = 0

#   depends_on = [
#     aws_security_group.websg
#   ]

# }

resource "aws_security_group" "appsg" {
  name        = var.appsg_config.name
  description = var.appsg_config.description
  vpc_id      = aws_vpc.ntier_vpc.id

  depends_on = [
    aws_vpc.ntier_vpc
  ]

}

resource "aws_security_group_rule" "appsg_rules" {
  count             = length(var.appsg_config.rules)
  type              = var.appsg_config.rules[count.index].type
  protocol          = var.appsg_config.rules[count.index].protocol
  security_group_id = aws_security_group.appsg.id
  cidr_blocks       = [var.appsg_config.rules[count.index].cidr_block]
  to_port           = var.appsg_config.rules[count.index].to_port
  from_port         = var.appsg_config.rules[count.index].from_port

  depends_on = [
    aws_security_group.appsg
  ]
}

resource "aws_security_group" "dbsg" {
  name        = var.dbsg_config.name
  description = var.dbsg_config.description
  vpc_id      = aws_vpc.ntier_vpc.id

  depends_on = [
    aws_vpc.ntier_vpc
  ]

}

resource "aws_security_group_rule" "dbsg_rules" {
  count             = length(var.dbsg_config.rules)
  type              = var.dbsg_config.rules[count.index].type
  protocol          = var.dbsg_config.rules[count.index].protocol
  security_group_id = aws_security_group.dbsg.id
  cidr_blocks       = [var.dbsg_config.rules[count.index].cidr_block]
  to_port           = var.dbsg_config.rules[count.index].to_port
  from_port         = var.dbsg_config.rules[count.index].from_port

  depends_on = [
    aws_security_group.dbsg
  ]
}