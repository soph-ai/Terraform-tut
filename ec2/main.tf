resource "aws_instance" "web-server-instance" {
  ami = var.ami_id 
  instance_type = var.instance_type 
  availability_zone = var.av_zone 
  key_name = var.key_name


  network_interface {
    network_interface_id = var.net_id
    device_index = 0
  }

  user_data = var.user_data

  tags = {
     Name = "web-server" 
  }
}

# jenks instance 
resource "aws_instance" "jenks-instance" {
  ami = var.ami_id 
  instance_type = "t2.medium" 
  availability_zone = var.av_zone 
  key_name = "ssh-aws-2"
  #security_groups = [aws_security_group.allow_web.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/ssh-aws-2.pem")
  }

  tags = {
    Name = "Jenkins_Server"
  }
}

#mySQL 
resource "aws_db_instance" "SQL" {
  identifier             = "sql"
  name                   = "SQL"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = "root"
  password               = var.db_password
  db_subnet_group_name   = var.subnet_group_name
  vpc_security_group_ids = [var.sec_group_id]
  parameter_group_name   = "default.mysql5.7"
  publicly_accessible    = false
  skip_final_snapshot    = true
}