# RDS instance endpoint output
# This provides the connection string for applications to connect to the database
output "db_endpoint" {
  description = "The connection endpoint (hostname) of the RDS database instance"
  value       = aws_db_instance.main.endpoint  # References the endpoint attribute from the RDS resource
  # This is used by applications to connect to the database
}

# RDS instance address output (hostname only)
# Provides just the hostname without the port for certain connection strings
output "db_address" {
  description = "The hostname of the RDS database instance (without port)"
  value       = aws_db_instance.main.address  # The address attribute contains just the hostname
  # Useful for applications that need just the hostname
}

# Database name output
# The name of the database that was created
output "db_name" {
  description = "The name of the initial database created in the RDS instance"
  value       = aws_db_instance.main.db_name  # References the database name from the RDS resource
  # This is the actual database name that applications should connect to
}

# RDS instance ID output
# The unique identifier for the RDS instance in AWS
output "db_instance_id" {
  description = "The unique identifier of the RDS database instance"
  value       = aws_db_instance.main.id  # The AWS resource ID for the RDS instance
  # Useful for AWS CLI commands and referencing in other resources
}

# RDS instance ARN output
# The Amazon Resource Name - a unique identifier across all AWS services
output "db_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the RDS database instance"
  value       = aws_db_instance.main.arn  # The full ARN including region and account ID
  # Required for IAM policies and cross-account access
}

# RDS instance port output
# The port number on which the database is listening
output "db_port" {
  description = "The port number on which the database accepts connections"
  value       = aws_db_instance.main.port  # The port attribute from the RDS resource
  # Default is 3306 for MySQL, but could be customized
}

# RDS instance username output
# The master username for the database (use with caution)
output "db_username" {
  description = "The master username for the RDS database instance"
  value       = aws_db_instance.main.username  # The username used for database authentication
  sensitive   = true  # Mark as sensitive to avoid showing in logs
  # Be careful when outputting usernames in production
}

# RDS availability zone output
# The primary availability zone where the database is deployed
output "db_availability_zone" {
  description = "The availability zone where the primary database instance is deployed"
  value       = aws_db_instance.main.availability_zone  # The AZ where the master instance runs
  # Useful for understanding deployment topology
}

# RDS multi-AZ status output
# Indicates whether Multi-AZ deployment is enabled
output "db_multi_az" {
  description = "Whether the RDS instance is deployed in Multiple Availability Zones"
  value       = aws_db_instance.main.multi_az  # Boolean indicating Multi-AZ status
  # Important for understanding high availability configuration
}

# RDS instance status output
# Current state of the database instance
output "db_status" {
  description = "The current status of the RDS database instance"
  value       = aws_db_instance.main.status  # Current state (available, backing-up, etc.)
  # Useful for monitoring and health checks
}

# RDS instance class output
# The type of instance being used (e.g., db.t2.micro)
output "db_instance_class" {
  description = "The instance class type of the RDS database"
  value       = aws_db_instance.main.instance_class  # The instance type (db.t2.micro, etc.)
  # Useful for cost tracking and performance monitoring
}

# RDS storage type output
# The type of storage being used (e.g., gp2, io1)
output "db_storage_type" {
  description = "The type of storage used by the RDS instance"
  value       = aws_db_instance.main.storage_type  # Storage type (gp2, gp3, io1)
  # Important for performance characteristics and cost
}

# RDS allocated storage output
# The amount of storage allocated to the database
output "db_allocated_storage" {
  description = "The amount of storage in gigabytes allocated to the database"
  value       = aws_db_instance.main.allocated_storage  # Storage size in GB
  # Useful for monitoring storage usage
}

# RDS max allocated storage output
# The maximum storage the database can auto-scale to
output "db_max_allocated_storage" {
  description = "The maximum amount of storage to which the database can auto-scale"
  value       = aws_db_instance.main.max_allocated_storage  # Maximum auto-scaling limit
  # Important for capacity planning
}

# RDS engine version output
# The version of the database engine
output "db_engine_version" {
  description = "The version of the database engine being used"
  value       = aws_db_instance.main.engine_version  # Database engine version (e.g., 5.7)
  # Useful for compatibility checks and upgrade planning
}

# RDS backup retention period output
# Number of days backups are retained
output "db_backup_retention_period" {
  description = "The number of days that automated backups are retained"
  value       = aws_db_instance.main.backup_retention_period  # Backup retention in days
  # Important for disaster recovery planning
}

# RDS backup window output
# The time window when backups occur
output "db_backup_window" {
  description = "The daily time range during which automated backups are created"
  value       = aws_db_instance.main.backup_window  # Backup time window
  # Useful for scheduling maintenance around backups
}

# RDS maintenance window output
# The time window for system maintenance
output "db_maintenance_window" {
  description = "The weekly time range for system maintenance"
  value       = aws_db_instance.main.maintenance_window  # Maintenance time window
  # Important for understanding when downtime might occur
}

# RDS parameter group name output
# The name of the parameter group being used
output "db_parameter_group_name" {
  description = "The name of the parameter group associated with the database"
  value       = aws_db_instance.main.parameter_group_name  # DB parameter group name
  # Useful for configuration management
}

# RDS option group name output
# The name of the option group being used
output "db_option_group_name" {
  description = "The name of the option group associated with the database"
  value       = aws_db_instance.main.option_group_name  # DB option group name
  # Important for understanding additional features enabled
}

# RDS publicly accessible status output
# Whether the database is accessible from the internet
output "db_publicly_accessible" {
  description = "Whether the database instance is publicly accessible"
  value       = aws_db_instance.main.publicly_accessible  # Boolean for public access
  # Critical for security monitoring
}

# RDS storage encrypted status output
# Whether the storage is encrypted at rest
output "db_storage_encrypted" {
  description = "Whether the database storage is encrypted at rest"
  value       = aws_db_instance.main.storage_encrypted  # Boolean for encryption status
  # Important for compliance and security
}

# RDS deletion protection status output
# Whether deletion protection is enabled
output "db_deletion_protection" {
  description = "Whether deletion protection is enabled for the database"
  value       = aws_db_instance.main.deletion_protection  # Boolean for deletion protection
  # Critical for preventing accidental deletion
}

# RDS performance insights status output
# Whether Performance Insights are enabled
output "db_performance_insights_enabled" {
  description = "Whether Performance Insights are enabled for the database"
  value       = aws_db_instance.main.performance_insights_enabled  # Boolean for Performance Insights
  # Useful for monitoring configuration
}

# RDS CA certificate identifier output
# The certificate authority for SSL connections
output "db_ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  value       = aws_db_instance.main.ca_cert_identifier  # CA certificate identifier
  # Important for SSL/TLS configuration
}

# RDS resource ID output
# The AWS-generated resource identifier
output "db_resource_id" {
  description = "The AWS-generated unique resource identifier for the RDS instance"
  value       = aws_db_instance.main.resource_id  # AWS internal resource ID
  # Used in some AWS APIs and for support cases
}

# Complete connection string output
# A formatted connection string for easy use
output "db_connection_string" {
  description = "A complete MySQL connection string for the database"
  value       = "mysql://${aws_db_instance.main.username}:${var.db_password}@${aws_db_instance.main.endpoint}/${aws_db_instance.main.db_name}"
  sensitive   = true  # Contains password, so mark as sensitive
  # Useful for quick testing but be careful with credentials
}

# DB subnet group name output
# The name of the DB subnet group used
output "db_subnet_group_name" {
  description = "The name of the DB subnet group associated with the RDS instance"
  value       = aws_db_subnet_group.main.name  # References the subnet group resource
  # Useful for network troubleshooting
}

# DB subnet group ID output
# The ID of the DB subnet group
output "db_subnet_group_id" {
  description = "The ID of the DB subnet group associated with the RDS instance"
  value       = aws_db_subnet_group.main.id  # The AWS resource ID of the subnet group
  # Useful for referencing in other resources
}