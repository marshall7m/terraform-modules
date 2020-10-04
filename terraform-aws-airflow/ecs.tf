# resource "aws_ecs_cluster" "airflow" {
#   name = "airflow-test"
# }

# resource "aws_ecs_task_definition" "local_exec_airflow" {
#   family                = "airflow"
#   container_definitions = jsonencode(
# [
#     {
#       "name": "first",
#       "image": "ecr:airflow_dags-commit-id",
#       "cpu": 10,
#       "memory": 512,
#       "essential": true,
#       "portMappings": [
#         {
#             "protocol": "tcp"
#             "containerPort": 8080,
#             "hostPort": 8080
#         }
#       ]
#     }
# ]
#   )

#   volume {
#     name      = "dags/"
#     host_path = "dags/"
#   }

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
#   }
# }