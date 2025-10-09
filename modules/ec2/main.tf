# Get the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name  # Your existing key

  # Network configuration
  network_interfaces {
    associate_public_ip_address = false  # No public IP (behind ALB)
    security_groups             = [var.app_security_group_id]
  }

  # User data script that runs on instance launch
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    environment = var.environment
    db_endpoint = var.db_endpoint
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  }))

  # Tag specifications for instances
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-app"
    }
  }

  # Lifecycle policy - create new before destroying old
  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group - manages EC2 instances
resource "aws_autoscaling_group" "app" {
  name_prefix         = "${var.environment}-app-"
  vpc_zone_identifier = var.private_subnet_ids  # Launch in private subnets
  desired_capacity    = 2  # Maintain 2 instances
  min_size           = 2   # Minimum 2 instances
  max_size           = 4   # Maximum 4 instances

  # Use the launch template
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"  # Always use latest version
  }

  # Attach to ALB target group
  target_group_arns = [var.target_group_arn]

  # Tags for Auto Scaling Group
  tag {
    key                 = "Name"
    value               = "${var.environment}-app"
    propagate_at_launch = true  # Apply to all instances
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  # Lifecycle policy
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns]
  }
}

# Scale-up policy - add instance when CPU high
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.environment}-scale-up"
  scaling_adjustment     = 1  # Add 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300  # 5 minutes cooldown
  autoscaling_group_name = aws_autoscaling_group.app.name
}

# Scale-down policy - remove instance when CPU low
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.environment}-scale-down"
  scaling_adjustment     = -1  # Remove 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

# CloudWatch alarm for high CPU - triggers scale-up
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"  # Trigger when > threshold
  evaluation_periods  = "2"     # 2 consecutive periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"   # 2 minutes
  statistic           = "Average"
  threshold           = "70"    # 70% CPU

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_description = "Scale up if CPU > 70% for 2 minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]  # Trigger scale-up
}

# CloudWatch alarm for low CPU - triggers scale-down
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.environment}-low-cpu"
  comparison_operator = "LessThanThreshold"  # Trigger when < threshold
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"    # 30% CPU

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_description = "Scale down if CPU < 30% for 2 minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]  # Trigger scale-down
}