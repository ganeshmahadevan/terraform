#Create private subnet
resource "aws_subnet" "prod-subnet-private-1" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "false" //it makes this a private subnet
    availability_zone = "ap-south-1a"
    tags =  {
        Name = "prod-subnet-private-1"
    }
}


#create custom route table
resource "aws_route_table" "prod-private-crt" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this NAT to reach internet
        gateway_id = "${aws_internet_gateway.prod-igw.id}" 
		
    }
    
    tags = {
        Name = "prod-private-crt"
    }
}



resource "aws_instance" "dbserver" {
  ami               = "ami-0e6329e222e662a52"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name = "ganesh"
  subnet_id = "${aws_subnet.prod-subnet-private-1.id}"
# Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  tags = {
        Name = "dbserver"
  }
}

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "Nat-Gateway-EIP" {
  depends_on = [
    aws_route_table_association.prod-crta-private-subnet-1
  ]
  vpc = true
}


# Creating a NAT Gateway!
resource "aws_nat_gateway" "NAT_GATEWAY" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.Nat-Gateway-EIP.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.prod-subnet-public-1.id
  tags = {
    Name = "Nat-Gateway_Project"
  }
}



#Associate RT with private subnet
resource "aws_route_table_association" "prod-crta-private-subnet-1"{
    subnet_id = "${aws_subnet.prod-subnet-private-1.id}"
    route_table_id = "${aws_route_table.prod-private-crt.id}"
}

