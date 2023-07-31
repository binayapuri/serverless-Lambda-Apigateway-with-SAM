#create VPC
resource "aws_vpc" "bpvpc" {
  cidr_block              = var.vpc_cidr
  tags      = {
    Name    = "bp-vpc"
  }
}


#retrive available zones on that region
data "aws_availability_zones" "available_zones" {


}

# create public subnet 1
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.bpvpc.id
  cidr_block              = var.public_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  tags      = {
    Name    = "bp-public_subnet"
  }
}

# create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.bpvpc.id
  tags      = {
    Name    = "bp-igw"
  }
}
# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.bpvpc.id
  route {
    cidr_block = var.allow_all
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags       = {
    Name    = "bp-public_RT"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet.id
  route_table_id      = aws_route_table.public_route_table.id
}

# create private data subnet in one zone
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                   = aws_vpc.bpvpc.id
  cidr_block               = var.private_cidr_1
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  tags      = {
    Name    = "bp-private-data_subnet_first"
  }
}

# create private data subnet in another zone
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                   = aws_vpc.bpvpc.id
  cidr_block               = var.private_cidr_2
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  tags      = {
    Name    = "bp-private-data_subnet_second"
  }
}