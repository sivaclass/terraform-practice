resource "aws_vpc" main {
  cidr_block = var.cidr_block
   
 tags = {
   Name = "Project VPC"
 }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}
resource "aws_subnet" "public" {
  count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone = local.availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = var.tags[count.index]
  } 
}

resource "aws_subnet" "private" {
  count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = local.availability_zone[count.index]
  # map_public_ip_on_launch = true
  tags = {
    Name = var.ptags[count.index]
  } 
}
resource "aws_subnet" "database" {
  count = length(var.database_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr_block[count.index]
  availability_zone = local.availability_zone[count.index]
  # map_public_ip_on_launch = true
  tags = {
    Name = var.dtags[count.index]
  } 
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}
resource "aws_eip" "EIP" {
  domain = "vpc"
  #depends_on  = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "ngt" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "gw NAT"
  }

    depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngt.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngt.id
  }

  tags = {
    Name = "database-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_cidr_block)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
