
locals {
  # ECS command script with variable substitution
  ecs_command_script = var.custom_ecs_command_script != null ? var.custom_ecs_command_script : join("", [
    "#!/bin/bash\n",
    "cat << INNER_EOF >> ~/.bash_profile\n",
    "export DB_NAME=${var.mongodb_database_config.db_name}\n",
    "export DB_USERNAME=${var.mongodb_database_config.db_user_name}\n",
    "export DB_PASSWORD=${var.mongodb_database_config.db_password}\n",
    "export ROS_DEPLOY=true\n",
    "INNER_EOF\n",
    "\n",
    "source ~/.bash_profile\n",
    "\n",
    "curl -fsSL https://help-static-aliyun-doc.aliyuncs.com/install-script/ecs-mongo-to-cloud/install_init.sh|bash\n"
  ])
}

# VPC Resources
resource "alicloud_vpc" "vpc" {
  vpc_name   = var.vpc_config.vpc_name
  cidr_block = var.vpc_config.cidr_block
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
}

# Security Group
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
  security_group_type = var.security_group_config.security_group_type
}

# Security Group Rules
resource "alicloud_security_group_rule" "rules" {
  for_each = var.security_group_rules

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  port_range        = each.value.port_range
  cidr_ip           = each.value.cidr_ip
  security_group_id = alicloud_security_group.security_group.id
}

# MongoDB Instance
resource "alicloud_mongodb_instance" "mongodb" {
  engine_version      = var.mongodb_config.engine_version
  db_instance_class   = var.mongodb_config.db_instance_class
  db_instance_storage = var.mongodb_config.db_instance_storage
  name                = var.mongodb_config.name
  account_password    = var.mongodb_config.account_password
  security_ip_list    = var.mongodb_config.security_ip_list
  vpc_id              = alicloud_vpc.vpc.id
  vswitch_id          = alicloud_vswitch.vswitch.id
  storage_engine      = var.mongodb_config.storage_engine
  storage_type        = var.mongodb_config.storage_type
}

# ECS Instance
resource "alicloud_instance" "mongodb_server" {
  instance_name              = var.instance_config.instance_name
  system_disk_category       = var.instance_config.system_disk_category
  image_id                   = var.instance_config.image_id
  vswitch_id                 = alicloud_vswitch.vswitch.id
  password                   = var.instance_config.password
  instance_type              = var.instance_config.instance_type
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
  security_groups            = [alicloud_security_group.security_group.id]
}

# ECS Command
resource "alicloud_ecs_command" "run_command" {
  name             = var.ecs_command_config.name
  description      = var.ecs_command_config.description
  enable_parameter = var.ecs_command_config.enable_parameter
  type             = var.ecs_command_config.type
  command_content  = base64encode(local.ecs_command_script)
  timeout          = var.ecs_command_config.timeout
  working_dir      = var.ecs_command_config.working_dir
}

# ECS Invocation
resource "alicloud_ecs_invocation" "install_mongodb" {
  instance_id = [alicloud_instance.mongodb_server.id]
  command_id  = alicloud_ecs_command.run_command.id
  depends_on  = [alicloud_mongodb_instance.mongodb, alicloud_instance.mongodb_server]

  timeouts {
    create = var.ecs_invocation_config.create_timeout
  }
}