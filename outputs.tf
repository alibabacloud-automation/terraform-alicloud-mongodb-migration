# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

# VSwitch Outputs
output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "vswitch_cidr_block" {
  description = "The CIDR block of the VSwitch"
  value       = alicloud_vswitch.vswitch.cidr_block
}

# Security Group Outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

# MongoDB Instance Outputs
output "mongodb_instance_id" {
  description = "The ID of the MongoDB instance"
  value       = alicloud_mongodb_instance.mongodb.id
}

output "mongodb_connection_string" {
  description = "The connection string for MongoDB instance"
  value       = "mongodb://root:${var.mongodb_config.account_password}@${alicloud_mongodb_instance.mongodb.replica_sets[0].connection_domain}:27017/${var.mongodb_database_config.db_name}"
  sensitive   = true
}

output "mongodb_replica_sets" {
  description = "The replica set information of MongoDB instance"
  value       = alicloud_mongodb_instance.mongodb.replica_sets
}

# ECS Instance Outputs
output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.mongodb_server.id
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.mongodb_server.primary_ip_address
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.mongodb_server.public_ip
}

# ECS Command Outputs
output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = alicloud_ecs_command.run_command.id
}

# ECS Invocation Outputs
output "ecs_invocation_id" {
  description = "The ID of the ECS invocation"
  value       = alicloud_ecs_invocation.install_mongodb.id
}

output "ecs_invocation_status" {
  description = "The status of the ECS invocation"
  value       = alicloud_ecs_invocation.install_mongodb.status
}