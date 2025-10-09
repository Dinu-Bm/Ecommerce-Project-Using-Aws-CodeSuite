# Security Group for Application Load Balancer (ALB)
# Controls traffic to and from the load balancer
resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"  # Security group name
  description = "Security group for ALB"     # Description for documentation
  vpc_id      = var.vpc_id                   # Which VPC this SG belongs to

  # Ingress rule for HTTP traffic
  ingress {
    description = "HTTP"                    # Rule description
    from_port   = 80                        # Starting port
    to_port     = 80                        # Ending port
    protocol    = "tcp"                     # Protocol (TCP for web traffic)
    cidr_blocks = ["0.0.0.0/0"]             # Allow from anywhere (entire internet)
  }

  # Ingress rule for HTTPS traffic
  ingress {
    description = "HTTPS"                   # For secure web traffic
    from_port   = 443                       # HTTPS port
    to_port     = 443                       # HTTPS port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]             # Allow from anywhere
  }

  # Egress rule (outbound traffic)
  egress {
    from_port   = 0                         # All ports
    to_port     = 0                         # All ports
    protocol    = "-1"                      # All protocols
    cidr_blocks = ["0.0.0.0/0"]             # Allow to anywhere
  }

  tags = {
    Name = "${var.environment}-alb-sg"      # Tag for identification
  }
}

# Security Group for Application Servers
# Controls traffic to and from EC2 instances
resource "aws_security_group" "app" {
  name        = "${var.environment}-app-sg"
  description = "Security group for application servers"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic only from ALB security group
  ingress {
    description     = "HTTP from ALB"       # Only allow HTTP from ALB
    from_port       = 80                    # Application port
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]  # Reference to ALB SG
  }

  # Allow SSH access for administration
  ingress {
    description = "SSH"                     # For SSH access
    from_port   = 22                        # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]             # Allow SSH from anywhere (be careful!)
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-app-sg"
  }
}

# Security Group for Database
# Controls access to the RDS database
resource "aws_security_group" "database" {
  name        = "${var.environment}-database-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  # Allow MySQL traffic only from application servers
  ingress {
    description     = "MySQL"               # Database traffic
    from_port       = 3306                  # MySQL default port
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]  # Only from app servers
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-database-sg"
  }
}

# Security Group for CodeDeploy
# For instances that will run CodeDeploy agent
resource "aws_security_group" "codedeploy" {
  name        = "${var.environment}-codedeploy-sg"
  description = "Security group for CodeDeploy instances"
  vpc_id      = var.vpc_id

  # Allow SSH for administration
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP for application
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-codedeploy-sg"
  }
}