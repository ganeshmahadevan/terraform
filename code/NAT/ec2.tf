resource "aws_instance" "webserver" {
  ami               = "ami-0e6329e222e662a52"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name = "ganesh"
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
# Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  tags = {
        Name = "webserver"
  }
}

