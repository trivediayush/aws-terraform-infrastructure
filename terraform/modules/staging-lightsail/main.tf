terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_lightsail_instance" "this" {
  name              = "${var.project_name}-${var.environment}-lightsail"
  availability_zone = data.aws_availability_zones.available.names[0]
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  user_data         = var.user_data

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-lightsail"
    }
  )
}

resource "aws_lightsail_instance_public_ports" "this" {
  instance_name = aws_lightsail_instance.this.name

  dynamic "port_info" {
    for_each = var.ports
    content {
      port_from = port_info.value.from
      port_to   = port_info.value.to
      protocol  = port_info.value.protocol
    }
  }
}
