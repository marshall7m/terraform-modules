locals {
  deployments = [
    {
      deployment_name = "deployment_one"
      dag_ids = [
        "sparkify_etl",
        "sparkify_analytics"
      ]
    }
  ]

  dag_access_tags_step_one = [
    for key,value in local.deployments[0]: [
        for tag in setproduct(list(key), try(tolist(value), list(value))): 
            map(tag[0], tag[1])
  ]
  ]
  dag_access_tags_step_two = setproduct(local.dag_access_tags_step_one...)

  dag_access_tags_step_three = {
      for tag_set in local.dag_access_tags_step_two: 
        merge(tag_set...)["dag_ids"] => merge(tag_set...)
  }

  dags_access_tags = {
      for tag_set in setproduct(
        [
            for key,value in local.deployments[0]: [
                for tag in setproduct(list(key), try(tolist(value), list(value))): 
                    map(tag[0], tag[1])
            ]
        ]...):
            merge(tag_set...)["dag_ids"] => merge(tag_set...)
  }
}
output "expected" {
    value = {
        "sparkify_etl" = {
            "dag_ids" = "sparkify_etl"
            "deployment_name" = "deployment_one"
        },
        "sparkify_analytics" = {
            "dag_ids" = "sparkify_analytics"
            "deployment_name" = "deployment_one"
        }
    }
}

output "one" {
    value = local.dag_access_tags_step_one
}

output "two" {
    value = local.dag_access_tags_step_two
}

output "three" {
    value = local.dag_access_tags_step_three
}

output "dags_access_tags" {
    value = local.dags_access_tags
}
