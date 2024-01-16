resource "aws_vpc" "hillel-demo-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "hillel-demo-vpc"
  }
}

resource "aws_subnet" "hillel-demo-public-subnet" {
  vpc_id                  = aws_vpc.hillel-demo-vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = "true" # it makes this a public subnet

  tags = {
    Name = "hillel-demo-public-subnet"
  }
}

resource "aws_subnet" "hillel-demo-private-subnet" {
  vpc_id     = aws_vpc.hillel-demo-vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "hillel-demo-private-subnet"
  }
}

resource "aws_eip" "hillel-demo-elastic-for-natgw" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.hillel-demo-gw]
}

resource "aws_nat_gateway" "hillel-demo-natgw" {
  allocation_id = aws_eip.hillel-demo-elastic-for-natgw.id
  subnet_id     = aws_subnet.hillel-demo-public-subnet.id

  tags = {
    Name = "Hillel demo NAT Gateway"
  }
}

resource "aws_route_table" "hillel-demo-private-rt" {
  vpc_id = aws_vpc.hillel-demo-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hillel-demo-natgw.id
  }

  tags = {
    Name = "Hillel demo private route table"
  }
}

resource "aws_route_table_association" "private-association" {
  subnet_id      = aws_subnet.hillel-demo-private-subnet.id
  route_table_id = aws_route_table.hillel-demo-private-rt.id
}

resource "aws_internet_gateway" "hillel-demo-gw" {
  vpc_id = aws_vpc.hillel-demo-vpc.id

  tags = {
    Name = "hillel-demo-gateway"
  }
}

resource "aws_route_table" "hillel-demo-public-rt" {
  vpc_id = aws_vpc.hillel-demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hillel-demo-gw.id
  }

  tags = {
    Name = "Hillel demo public route table"
  }
}

resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.hillel-demo-public-subnet.id
  route_table_id = aws_route_table.hillel-demo-public-rt.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.hillel-demo-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
