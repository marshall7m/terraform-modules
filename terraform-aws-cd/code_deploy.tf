
resource "aws_codedeploy_app" "this" {
  count = var.create_cd_app ? 1 : 0
  compute_platform = var.cd_app_compute_platform
  name             = var.cd_app_name
}

resource "aws_codedeploy_deployment_config" "this" {
  count = var.create_cd_config ? 1 : 0
  deployment_config_name = var.cd_config_name

  dynamic "minimum_healthy_hosts" {
    for_each = var.cd_config_minimum_healthy_hosts
    content {
      type = minimum_healthy_hosts.value.type
      value = minimum_healthy_hosts.value.value
    }
  }

  dynamic "traffic_routing_config" {
    for_each = var.cd_config_traffic_routing_config
    content {
      type = traffic_routing_config.value.type
      
      dynamic "time_based_canary" {
        for_each = traffic_routing_config.value.time_based_canary
        content {
          interval = time_based_canary.value.interval
          percentage = time_based_canary.value.percentage
        }
      }

      dynamic "time_based_linear" {
        for_each = traffic_routing_config.value.time_based_linear
        content {
          interval = time_based_linear.value.interval
          percentage = time_based_linear.value.percentage
        }
      }
    }
  }
}


resource "aws_codedeploy_deployment_group" "this" {
  app_name               = var.cd_app_name
  deployment_group_name  = var.cd_group_name
  service_role_arn       = var.cd_group_role_arn
  deployment_config_name = var.cd_config_name
  
  dynamic "deployment_style" {
    for_each = [var.cd_group_deployment_style]
    content {
      deployment_option = deployment_style.value["deployment_option"]
      deployment_type = deployment_style.value["deployment_type"]
    }
  }

  dynamic "load_balancer_info" {
    for_each = var.cd_group_load_balancer_info
    content {
      dynamic "elb_info" {
        for_each = load_balancer_info.value.elb_info
        content {
          name = elb_info.value.name
        }
      }

      dynamic "target_group_info" {
        for_each = load_balancer_info.value.target_group_info
        content {
          name = target_group_info.value.name
        }
      }
      
      dynamic "target_group_pair_info" {
        for_each = load_balancer_info.value.target_group_pair_info
        content {
          dynamic "prod_traffic_route" {
            for_each = target_group_pair_info.value
            content {
              listener_arns = prod_traffic_route.value.listener_arns
            }
          }
          dynamic "target_group" {
            for_each = target_group_pair_info.value
            content {
              name = target_group.value.name
            }
          }
          dynamic "test_traffic_route" {
            for_each = target_group_pair_info.value
            content {
              listener_arns = test_traffic_route.value.listener_arns
            }
          }
        }
      }
    }
  }

    

  dynamic "blue_green_deployment_config" {
    for_each = var.cd_group_blue_green_deployment_config
    content {
      dynamic "deployment_ready_option" {
        for_each = blue_green_deployment_config.value.deployment_ready_option
        content {
          action_on_timeout = deployment_ready_option.value.action_on_timeout
          wait_time_in_minutes = deployment_ready_option.value.wait_time_in_minutes
        }
      }

      dynamic "green_fleet_provisioning_option" {
        for_each = blue_green_deployment_config.value.green_fleet_provisioning_option
        content {
          action = green_fleet_provisioning_option.value.action
        }
      }

      dynamic "terminate_blue_instances_on_deployment_success" {
        for_each = blue_green_deployment_config.value.terminate_blue_instances_on_deployment_success
        content {
          action = terminate_blue_instances_on_deployment_success.value.action
          termination_wait_time_in_minutes  = terminate_blue_instances_on_deployment_success.value.termination_wait_time_in_minutes
        }
      } 
    }
  }

  dynamic "ec2_tag_set" {
    for_each = var.cd_group_ec2_tag_set
    content {
      dynamic "ec2_tag_filter" {
        for_each = ec2_tag_set.value
        content {
          key = ec2_tag_filter.value.key
          type = coalesce(
            ec2_tag_filter.value.key != null && ec2_tag_filter.value.value != null ? "KEY_AND_VALUE" : null,
            ec2_tag_filter.value.key != null && ec2_tag_filter.value.value == null ? "KEY_ONLY" : null,
            ec2_tag_filter.value.key == null && ec2_tag_filter.value.value != null ? "VALUE_ONLY" : null
          )
          value = ec2_tag_filter.value.value
        }
      }
    }
  }

  dynamic "ec2_tag_filter" {
    for_each = var.cd_group_ec2_tag_filters 
    content {
      key = ec2_tag_filter.value.key
      type = coalesce(
        ec2_tag_filter.value.key != null && ec2_tag_filter.value.value != null ? "KEY_AND_VALUE" : null,
        ec2_tag_filter.value.key != null && ec2_tag_filter.value.value == null ? "KEY_ONLY" : null,
        ec2_tag_filter.value.key == null && ec2_tag_filter.value.value != null ? "VALUE_ONLY" : null
      )
      value = ec2_tag_filter.value.value
    }
  }

  dynamic "auto_rollback_configuration" {
    for_each = [var.cd_group_auto_rollback_configuration]
    content {
      enabled = auto_rollback_configuration.value.enabled
      events = auto_rollback_configuration.value.events
    }
  }
}