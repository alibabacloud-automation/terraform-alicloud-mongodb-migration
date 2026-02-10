# VPC Configuration
variable "vpc_config" {
  description = "Configuration for VPC. The attribute 'cidr_block' is required."
  type = object({
    vpc_name   = optional(string, "mongodb-migration-vpc")
    cidr_block = string
  })
}

# VSwitch Configuration
variable "vswitch_config" {
  description = "Configuration for VSwitch. The attributes 'cidr_block' and 'zone_id' are required."
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, "mongodb-migration-vswitch")
  })
}

# Security Group Configuration
variable "security_group_config" {
  description = "Configuration for security group."
  type = object({
    security_group_name = optional(string, "mongodb-migration-sg")
    security_group_type = optional(string, "normal")
  })
  default = {}
}

# Security Group Rules Configuration
variable "security_group_rules" {
  description = "Map of security group rules configuration."
  type = map(object({
    type        = string
    ip_protocol = string
    port_range  = string
    cidr_ip     = string
  }))
  default = {
    http = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = "0.0.0.0/0"
    }
    rdp = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "3389/3389"
      cidr_ip     = "0.0.0.0/0"
    }
    mongodb_ingress = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "27017/27017"
      cidr_ip     = "0.0.0.0/0"
    }
    mongodb_egress = {
      type        = "egress"
      ip_protocol = "tcp"
      port_range  = "27017/27017"
      cidr_ip     = "0.0.0.0/0"
    }
  }
}

# MongoDB Instance Configuration
variable "mongodb_config" {
  description = "Configuration for MongoDB instance. The attributes 'db_instance_class' and 'account_password' are required."
  type = object({
    engine_version      = optional(string, "8.0")
    db_instance_class   = string
    db_instance_storage = optional(number, 20)
    name                = optional(string, "mongodb-migration-instance")
    account_password    = string
    security_ip_list    = optional(list(string), ["192.168.1.0/24"])
    storage_engine      = optional(string, "WiredTiger")
    storage_type        = optional(string, "cloud_essd1")
  })
  sensitive = true
}

# ECS Instance Configuration
variable "instance_config" {
  description = "Configuration for ECS instance. The attributes 'image_id', 'instance_type', and 'password' are required."
  type = object({
    instance_name              = optional(string, "mongodb-migration-server")
    system_disk_category       = optional(string, "cloud_essd")
    image_id                   = string
    password                   = string
    instance_type              = string
    internet_max_bandwidth_out = optional(number, 5)
  })
  default = {
    image_id      = null
    password      = null
    instance_type = null
  }
  sensitive = true
}

# Database Configuration for ECS Command Script
variable "mongodb_database_config" {
  description = "Database configuration for MongoDB migration script. The attributes 'db_name', 'db_user_name', and 'db_password' are required."
  type = object({
    db_name      = string
    db_user_name = string
    db_password  = string
  })
  sensitive = true

}

# ECS Command Configuration
variable "ecs_command_config" {
  description = "Configuration for ECS command."
  type = object({
    name             = optional(string, "mongodb-migration-command")
    description      = optional(string, "MongoDB migration initialization command")
    enable_parameter = optional(bool, false)
    type             = optional(string, "RunShellScript")
    timeout          = optional(number, 3600)
    working_dir      = optional(string, "/root")
  })
  default = {}
}

# ECS Invocation Configuration
variable "ecs_invocation_config" {
  description = "Configuration for ECS invocation."
  type = object({
    create_timeout = optional(string, "10m")
  })
  default = {}
}

# Custom ECS Command Script
variable "custom_ecs_command_script" {
  description = "Custom ECS command script for MongoDB migration. If not provided, the default script will be used."
  type        = string
  default     = null
  sensitive   = true
}