# Environment name variable
# This identifies which environment (dev, staging, prod) the resources belong to
variable "environment" {
  description = "The name of the environment (e.g., dev, staging, prod) for resource tagging and naming"
  type        = string  # Must be a text string
}

# RDS instance type variable
# Defines the database instance size and performance characteristics
variable "instance_type" {
  description = "The RDS instance class type (e.g., db.t2.micro, db.t3.small) - db.t2.micro is free tier eligible"
  type        = string
  default     = "db.t2.micro"  # Default to free tier eligible instance
}

# Database name variable
# The name of the initial database created when RDS instance is launched
variable "db_name" {
  description = "The name of the initial database to create when the RDS instance is launched"
  type        = string
  default     = "ecommercedb"  # Default database name for e-commerce application
}

# Database username variable
# The master username for the RDS instance - used for administrative access
variable "db_username" {
  description = "The master username for the RDS instance database administrator"
  type        = string
  default     = "admin"  # Default admin username
}

# Database password variable
# The master password for the RDS instance - marked as sensitive for security
variable "db_password" {
  description = "The master password for the RDS instance database administrator"
  type        = string
  sensitive   = false  # Prevents the password from being shown in logs or outputs
}

# List of private subnet IDs variable
# Defines which subnets the RDS instance can be deployed in for high availability
variable "private_subnet_ids" {
  description = "A list of private subnet IDs where the RDS instance can be deployed across multiple availability zones"
  type        = list(string)  # Must be a list of string values
}

# Database security group ID variable
# References the security group that controls database network access
variable "security_group_id" {
  description = "The ID of the security group that controls network access to the RDS instance"
  type        = string
}

# Database engine type variable
# Specifies which database engine to use (MySQL, PostgreSQL, etc.)
variable "engine" {
  description = "The database engine type to use (e.g., mysql, postgres, mariadb)"
  type        = string
  default     = "mysql"  # Default to MySQL as it's widely supported
}

# Database engine version variable
# Specifies the version of the database engine
variable "engine_version" {
  description = "The version of the database engine to use"
  type        = string
  default     = "5.7"  # MySQL 5.7 is free tier compatible and stable
}

# Allocated storage size variable
# Defines the initial storage size for the database in gigabytes
variable "allocated_storage" {
  description = "The amount of storage in gigabytes to allocate for the database"
  type        = number  # Must be a numerical value
  default     = 20      # Default 20GB (free tier includes 20GB)
}

# Maximum allocated storage variable
# Defines the upper limit for storage auto-scaling
variable "max_allocated_storage" {
  description = "The maximum amount of storage in gigabytes to which the database can automatically scale"
  type        = number
  default     = 100     # Auto-scale up to 100GB if needed
}

# Storage type variable
# Defines the type of storage (SSD, Provisioned IOPS, etc.)
variable "storage_type" {
  description = "The type of storage to use for the database (e.g., gp2, gp3, io1)"
  type        = string
  default     = "gp2"   # Default to General Purpose SSD (good balance of performance and cost)
}

# Multi-AZ deployment variable
# Controls whether database is replicated across multiple availability zones
variable "multi_az" {
  description = "Whether to deploy the database in multiple availability zones for high availability"
  type        = bool    # Must be true or false
  default     = false   # Default to false for free tier (true would cost more)
}

# Publicly accessible variable
# Controls whether database can be accessed from the internet
variable "publicly_accessible" {
  description = "Whether the database instance is publicly accessible from the internet"
  type        = bool
  default     = false   # Default to false for security (only accessible within VPC)
}

# Backup retention period variable
# Number of days to keep automated backups
variable "backup_retention_period" {
  description = "The number of days to retain automated backups of the database"
  type        = number
  default     = 0       # Default 7 days of backups
}

# Backup window variable
# The time window when automated backups occur
variable "backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00"  # Default backup window: 3-4 AM UTC
}

# Maintenance window variable
# The time window for system maintenance and updates
variable "maintenance_window" {
  description = "The weekly time range for system maintenance"
  type        = string
  default     = "sun:04:00-sun:05:00"  # Default maintenance: Sunday 4-5 AM UTC
}

# Skip final snapshot variable
# Controls whether to skip final snapshot when destroying database
variable "skip_final_snapshot" {
  description = "Whether to skip creating a final snapshot when the database instance is destroyed"
  type        = bool
  default     = true    # Default to true for development (set to false in production!)
}

# Apply immediately variable
# Controls whether changes are applied immediately or during maintenance window
variable "apply_immediately" {
  description = "Whether to apply database changes immediately or wait for the maintenance window"
  type        = bool
  default     = true    # Default to true for immediate application of changes
}

# Database port variable
# The port number on which the database accepts connections
variable "port" {
  description = "The port number on which the database accepts connections"
  type        = number
  default     = 3306    # Default MySQL port
}

# Storage encrypted variable
# Controls whether database storage is encrypted at rest
variable "storage_encrypted" {
  description = "Whether to encrypt the database storage at rest"
  type        = bool
  default     = true    # Default to true for security
}

# Parameter group name variable
# References the database parameter group for configuration
variable "parameter_group_name" {
  description = "The name of the DB parameter group to associate with the instance"
  type        = string
  default     = "default.mysql5.7"  # Default parameter group for MySQL 5.7
}

# Deletion protection variable
# Prevents accidental deletion of the database instance
variable "deletion_protection" {
  description = "Whether to enable deletion protection for the database instance"
  type        = bool
  default     = false   # Default to false for development (true in production)
}

# Performance Insights enabled variable
# Controls whether Performance Insights are enabled for monitoring
variable "performance_insights_enabled" {
  description = "Whether to enable Performance Insights for database monitoring"
  type        = bool
  default     = false   # Default to false to avoid additional costs
}

# Copy tags to snapshot variable
# Controls whether instance tags are copied to snapshots
variable "copy_tags_to_snapshot" {
  description = "Whether to copy all instance tags to snapshots"
  type        = bool
  default     = true    # Default to true for better resource management
}

# Auto minor version upgrade variable
# Controls whether minor engine upgrades are applied automatically
variable "auto_minor_version_upgrade" {
  description = "Whether to automatically apply minor engine version upgrades"
  type        = bool
  default     = true    # Default to true for automatic security patches
}