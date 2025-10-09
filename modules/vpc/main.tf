# Create VPC (Virtual Private Cloud) - our isolated network in AWS
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr  # IP range for the VPC
  enable_dns_hostnames = true          # Enable DNS hostnames for instances
  enable_dns_support   = true          # Enable DNS resolution

  tags = {
    Name = "${var.environment}-vpc"  # Tag with environment name
  }
}

# Create Internet Gateway - allows communication with the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  # Attach to our VPC

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Create Public Subnets - instances here can have public IPs
resource "aws_subnet" "public" {
  count = length(var.availability_zones)  # Create one subnet per AZ
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)  # Calculate subnet CIDR
  availability_zone       = var.availability_zones[count.index]  # Distribute across AZs
  map_public_ip_on_launch = true  # Automatically assign public IPs

  tags = {
    Name = "${var.environment}-public-${var.availability_zones[count.index]}"
  }
}

# Create Private Subnets for Application - no public IPs
resource "aws_subnet" "private_app" {
  count = length(var.availability_zones)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)  # Different CIDR range
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-app-${var.availability_zones[count.index]}"
  }
}

# Create Private Subnets for Database - most restricted
resource "aws_subnet" "private_db" {
  count = length(var.availability_zones)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 20)  # Another CIDR range
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-db-${var.availability_zones[count.index]}"
  }
}

# Create Public Route Table - defines how traffic routes from public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Route to internet through Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"        # All internet traffic
    gateway_id = aws_internet_gateway.main.id  # Send to IGW
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

# Create Private Route Table - for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate Private App Subnets with Private Route Table
resource "aws_route_table_association" "private_app" {
  count = length(aws_subnet.private_app)
  
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private.id
}

# Associate Private DB Subnets with Private Route Table
resource "aws_route_table_association" "private_db" {
  count = length(aws_subnet.private_db)
  
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private.id
}