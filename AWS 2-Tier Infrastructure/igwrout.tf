# Create Internet Gateway
resource "aws_internet_gateway" "ig_az" {
  tags = {
    Name = "internet_gateway_az"
  }
  vpc_id = aws_vpc.azcloud.id
}

# Create Route Table
resource "aws_route_table" "route_table1" {
  tags = {
    Name = "route_table_1"
  }
  vpc_id = aws_vpc.azcloud.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_az.id
  }
}

# Create Route Table Association
resource "aws_route_table_association" "route_table_association1" {
  subnet_id      = aws_subnet.public_subnet1a.id
  route_table_id = aws_route_table.route_table1.id
}

resource "aws_route_table_association" "route_table_association2" {
  subnet_id      = aws_subnet.public_subnet1b.id
  route_table_id = aws_route_table.route_table1.id
}