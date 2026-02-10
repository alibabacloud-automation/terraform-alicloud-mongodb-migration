# Region Configuration
variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "cn-shanghai"
}

# VPC Configuration
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "mongodb-migration-vpc"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

# VSwitch Configuration
variable "vswitch_name" {
  description = "The name of the VSwitch"
  type        = string
  default     = "mongodb-migration-vswitch"
}

variable "vswitch_cidr_block" {
  description = "The CIDR block for the VSwitch"
  type        = string
  default     = "192.168.1.0/24"
}

# Security Group Configuration
variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "mongodb-migration-sg"
}

# MongoDB Configuration
variable "mongodb_engine_version" {
  description = "MongoDB engine version"
  type        = string
  default     = "8.0"
}

variable "mongodb_instance_class" {
  description = "MongoDB instance class"
  type        = string
  default     = "mdb.shard.2x.xlarge.d"
}

variable "mongodb_storage" {
  description = "MongoDB storage size in GB"
  type        = number
  default     = 20
}

variable "mongodb_instance_name" {
  description = "MongoDB instance name"
  type        = string
  default     = "mongodb-migration-instance"
}

variable "mongodb_password" {
  description = "MongoDB root password"
  type        = string
  sensitive   = true
  default     = "Test12345678!"
}

# ECS Configuration
variable "ecs_instance_name" {
  description = "ECS instance name"
  type        = string
  default     = "mongodb-migration-server"
}

variable "ecs_instance_password" {
  description = "ECS instance login password"
  type        = string
  sensitive   = true
  default     = "Test12345678!"
}

variable "internet_bandwidth" {
  description = "Internet bandwidth for ECS instance"
  type        = number
  default     = 5
}

# Database Configuration
variable "db_name" {
  description = "Self-managed MongoDB database name"
  type        = string
  default     = "mongodb_transfer_test"
}

variable "db_user_name" {
  description = "Self-managed MongoDB database username"
  type        = string
  default     = "mongouser"
}

variable "db_password" {
  description = "Self-managed MongoDB database password"
  type        = string
  sensitive   = true
  default     = "Test12345678!"
}

# ECS Command Configuration
variable "ecs_command_name" {
  description = "ECS command name"
  type        = string
  default     = "mongodb-migration-command"
}