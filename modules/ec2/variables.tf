variable "environment" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "app_security_group_id" { type = string }
variable "target_group_arn" { type = string }
variable "db_endpoint" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "scale_up_threshold" {
  type    = number
  default = 70
}

variable "scale_down_threshold" {
  type    = number
  default = 30
}

variable "cooldown_period" {
  type    = number
  default = 300
}
