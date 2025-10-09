# Environment name variable
# This identifies which environment (dev, staging, prod) the resources belong to
variable "environment" {
  description = "The name of the environment (e.g., dev, staging, prod) for resource tagging and naming"
  type        = string  # Must be a text string
}

# EC2 instance type variable
# Defines the size and capacity of the EC2 instances
variable "instance_type" {
  description = "The EC2 instance type to use for application servers (e.g., t2.micro, t3.small)"
  type        = string
  default     = "t2.micro"  # Default to free tier eligible instance
}

# EC2 key pair name variable
# References your existing key pair for SSH access
variable "key_name" {
  description = "The name of an existing EC2 Key Pair to enable SSH access to the instances"
  type        = string
}

# List of private subnet IDs variable
# Defines where the EC2 instances will be launched
variable "private_subnet_ids" {
  description = "A list of private subnet IDs where the EC2 instances will be launched"
  type        = list(string)  # Must be a list of strings
}

# Application security group ID variable
# References the security group that controls instance traffic
variable "app_security_group_id" {
  description = "The ID of the security group that controls traffic to the application instances"
  type        = string
}

# ALB target group ARN variable
# Links the instances to the load balancer
variable "target_group_arn" {
  description = "The ARN (Amazon Resource Name) of the ALB target group to register instances with"
  type        = string
}

# Database endpoint variable
# Connection string for the RDS database
variable "db_endpoint" {
  description = "The endpoint (hostname) of the RDS database instance for application connectivity"
  type        = string
}

# Database name variable
# Name of the specific database to connect to
variable "db_name" {
  description = "The name of the database to connect to within the RDS instance"
  type        = string
  default     = "ecommercedb"  # Default database name
}

# Database username variable
# Username for database authentication
variable "db_username" {
  description = "The username for authenticating with the database"
  type        = string
}

# Database password variable
# Password for database authentication (marked as sensitive)
variable "db_password" {
  description = "The password for authenticating with the database"
  type        = string
  sensitive   = false  # Prevents the value from being shown in logs/outputs
}

# Minimum size for Auto Scaling Group variable
# Defines the smallest number of instances to maintain
variable "min_size" {
  description = "The minimum number of EC2 instances to maintain in the Auto Scaling Group"
  type        = number  # Must be a number
  default     = 2       # Default minimum of 2 instances for high availability
}

# Maximum size for Auto Scaling Group variable
# Defines the largest number of instances allowed
variable "max_size" {
  description = "The maximum number of EC2 instances allowed in the Auto Scaling Group"
  type        = number
  default     = 4       # Default maximum of 4 instances
}

# Desired capacity for Auto Scaling Group variable
# Defines the ideal number of instances to run
variable "desired_capacity" {
  description = "The desired number of EC2 instances to run in the Auto Scaling Group"
  type        = number
  default     = 2       # Default to 2 instances
}

# Scale-up CPU threshold variable
# CPU percentage that triggers adding more instances
variable "scale_up_threshold" {
  description = "The CPU utilization percentage that triggers scaling up (adding instances)"
  type        = number
  default     = 70      # Scale up when CPU reaches 70%
}

# Scale-down CPU threshold variable
# CPU percentage that triggers removing instances
variable "scale_down_threshold" {
  description = "The CPU utilization percentage that triggers scaling down (removing instances)"
  type        = number
  default     = 30      # Scale down when CPU drops below 30%
}

# Cooldown period variable
# Time to wait between scaling actions
variable "cooldown_period" {
  description = "The time in seconds to wait after a scaling activity before allowing another scaling activity"
  type        = number
  default     = 300     # Default 5 minutes cooldown
}

# Health check grace period variable
# Time for instances to become healthy before checks start
variable "health_check_grace_period" {
  description = "Time in seconds after instance comes into service before checking health"
  type        = number
  default     = 300     # Default 5 minutes grace period
}

# Enable detailed monitoring variable
# Controls whether enhanced CloudWatch monitoring is enabled
variable "enable_detailed_monitoring" {
  description = "Whether to enable detailed CloudWatch monitoring for instances (incurs additional cost)"
  type        = bool    # Must be true or false
  default     = false   # Default to basic monitoring to save costs
}

# Root volume size variable
# Size of the root EBS volume in GB
variable "root_volume_size" {
  description = "The size of the root EBS volume in gigabytes"
  type        = number
  default     = 20      # Default 20GB (free tier includes 30GB)
}

# Root volume type variable
# Type of EBS volume (gp2, gp3, io1, etc.)
variable "root_volume_type" {
  description = "The type of EBS volume for the root device (e.g., gp2, gp3)"
  type        = string
  default     = "gp2"   # Default to General Purpose SSD
}

# Enable termination protection variable
# Prevents accidental instance termination
variable "enable_termination_protection" {
  description = "Whether to enable termination protection for instances"
  type        = bool
  default     = false   # Default to false for easier management in dev
}