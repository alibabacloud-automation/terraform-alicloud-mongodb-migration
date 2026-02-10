# Provider configuration
provider "alicloud" {
  region = var.region
}

data "alicloud_mongodb_zones" "default" {
}

data "alicloud_instance_types" "default" {
  system_disk_category = "cloud_essd"
  image_id             = data.alicloud_images.default.images[0].id
  instance_type_family = "ecs.c6"
  availability_zone    = data.alicloud_mongodb_zones.default.zones[0].id
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_*"
  most_recent = true
  owners      = "system"
}
# Use the module
module "mongodb_migration" {
  source = "../../"

  # VPC configuration
  vpc_config = {
    vpc_name   = var.vpc_name
    cidr_block = var.vpc_cidr_block
  }

  # VSwitch configuration
  vswitch_config = {
    cidr_block   = var.vswitch_cidr_block
    zone_id      = data.alicloud_mongodb_zones.default.zones[0].id
    vswitch_name = var.vswitch_name
  }

  # Security group configuration
  security_group_config = {
    security_group_name = var.security_group_name
    security_group_type = "normal"
  }

  security_group_rules = {
    http = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = var.vswitch_cidr_block
    }
    rdp = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "3389/3389"
      cidr_ip     = var.vswitch_cidr_block
    }
    mongodb_ingress = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "27017/27017"
      cidr_ip     = var.vswitch_cidr_block
    }
    mongodb_egress = {
      type        = "egress"
      ip_protocol = "tcp"
      port_range  = "27017/27017"
      cidr_ip     = var.vswitch_cidr_block
    }
  }

  # MongoDB configuration
  mongodb_config = {
    engine_version      = var.mongodb_engine_version
    db_instance_class   = var.mongodb_instance_class
    db_instance_storage = var.mongodb_storage
    name                = var.mongodb_instance_name
    account_password    = var.mongodb_password
    security_ip_list    = [var.vswitch_cidr_block]
    storage_engine      = "WiredTiger"
    storage_type        = "cloud_essd1"
  }

  # ECS instance configuration
  instance_config = {
    instance_name              = var.ecs_instance_name
    system_disk_category       = "cloud_essd"
    image_id                   = data.alicloud_images.default.images[0].id
    password                   = var.ecs_instance_password
    instance_type              = data.alicloud_instance_types.default.instance_types[0].id
    internet_max_bandwidth_out = var.internet_bandwidth
  }

  # Database configuration for migration script
  mongodb_database_config = {
    db_name      = var.db_name
    db_user_name = var.db_user_name
    db_password  = var.db_password
  }

  # ECS command configuration
  ecs_command_config = {
    name             = var.ecs_command_name
    description      = "MongoDB migration initialization command"
    enable_parameter = false
    type             = "RunShellScript"
    timeout          = 3600
    working_dir      = "/root"
  }

  # ECS invocation configuration
  ecs_invocation_config = {
    create_timeout = "10m"
  }
}