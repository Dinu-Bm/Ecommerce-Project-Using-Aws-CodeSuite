resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr          
  enable_dns_hostnames = true                  
  enable_dns_support   = true                  

  tags = {
    Name = "${var.environment}-vpc"  
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  

  tags = {
    Name = "${var.environment}-igw"  
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones) 
  vpc_id                  = aws_vpc.main.id               
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index) 
  availability_zone       = var.availability_zones[count.index]       
  map_public_ip_on_launch = true  

  tags = {
    Name = "${var.environment}-public-${var.availability_zones[count.index]}"  
  }
}

resource "aws_subnet" "private_app" {
  count             = length(var.availability_zones)  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)  
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-app-${var.availability_zones[count.index]}"
  }
}

resource "aws_subnet" "private_db" {
  count             = length(var.availability_zones)  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 20) 
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-db-${var.availability_zones[count.index]}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"        
    gateway_id = aws_internet_gateway.main.id  
  }

  tags = {
    Name = "${var.environment}-public-rt"  
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)  
  subnet_id      = aws_subnet.public[count.index].id     
  route_table_id = aws_route_table.public.id  
}

resource "aws_route_table_association" "private_app" {
  count          = length(aws_subnet.private_app)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {
  count          = length(aws_subnet.private_db)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private.id
}