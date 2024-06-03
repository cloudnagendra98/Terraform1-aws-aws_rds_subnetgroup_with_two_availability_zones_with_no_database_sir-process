data "aws_subnets" "db" {
  filter {
    name   = "tag:Name"
    values = var.db_subnet_names
  }
  depends_on = [
    aws_subnet.subnet1 # dont create this beofre subnets are created because querying the information
    # before subnets are created is not make much of sense so use depends_on here as aws_subnet.subnet1
  ]
}

#create a dbsubnet group
resource "aws_db_subnet_group" "ntier" {
  #subnet_ids = [aws_subnet.subnet1[4].id, aws_subnet.subnet1[5].id] 
  # can we write like this as 4 and 5 mentioning as leftside.
  #answer is no, because rightnow i am giving input of 6 subnets but tomorrow i might give input of 10 subnets or 12 subnets so
  # to achieve such dynamic values automatically its not possible. as we dont knw fr which subnet id im talkint about. 
  #for that what we have to achieve is  we have to figure out a way db1 has a index of 4 and db2 has a index of 5. 
  #did you understand so what we do is... we replace subnet_ids = [aws_subnet.subnet1[4].id, aws_subnet.subnet1[5].id]
  #as below. so i commented it and go to terraform documentation and there search for index function in collections and use it.
  # https://developer.hashicorp.com/terraform/language/functions/index_function 

  name       = "ntier"
  subnet_ids = data.aws_subnets.db.ids #but here we have to write 2 subnets ids together in one line or one shot how 
  #to do that so go to top of this section and search in terraform registry for aws provider and search for aws_subnets in 
  # datasources in vpc section which would be like this data "aws_subnets" "" { filter {}}
  # we defined subnet_ids = data.aws_subnets.db.ids as after we did terraform refresh -var-file="dev.tfvars" then terraform console
  # then we executed this in terraform console > data.aws_subnets.db.ids then it fetched those 2 subnets ids which we got into 
  #aws console when you got created while terraform apply -var-file="dev.tfvars" which we did before terraform refresh executed..
  tags = {
    Name = "ntier"
  }
  depends_on = [
    aws_subnet.subnet1,
    data.aws_subnets.db
  ]

}

# resource "aws_db_instance" "dbntier" {

#   allocated_storage    = 20
#   db_name              = "mydb"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   username             = "user"
#   password             = "useruser"
#   skip_final_snapshot  = true
#   db_subnet_group_name = aws_db_subnet_group.ntier.name
#   identifier = "myntierdbfromtf"

# depends_on = [ 

#     aws_db_subnet_group.ntier ]


# }