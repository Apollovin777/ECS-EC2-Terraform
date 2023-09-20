##### ECS-Cluster #####
resource "aws_ecs_cluster" "cluster" {
  name = "ecs-folderit-cluster"
}

##### AWS ECS-TASK #####
resource "aws_ecs_task_definition" "task_definition" {
  container_definitions    = data.template_file.task_definition_json.rendered # task defination json file location
  family                   = "folderit-task-defination-webservice"            # task name
  network_mode             = "host"                                         # network mode awsvpc, brigde
  memory                   = "512"
  cpu                      = "512"
  requires_compatibilities = ["EC2"] # Fargate or EC2
}

data "template_file" "task_definition_json" {
  template = format("[%s,%s]",file("TaskDefinitions/auth_task.tpl.json"),
                            file("TaskDefinitions/weather_task.tpl.json"))
  vars = {
    rep_url = var.repository_url
  }
} 

##### AWS ECS-SERVICE #####
resource "aws_ecs_service" "service-webservice" {
  cluster         = aws_ecs_cluster.cluster.id                  # ECS Cluster ID
  desired_count   = 1                                           # Number of tasks running
  launch_type     = "EC2"                                       # Cluster type [ECS OR FARGATE]
  name            = "folderit-webservice-service-webservice"    # Name of service
  task_definition = aws_ecs_task_definition.task_definition.arn # Attach the task to service
  load_balancer {
    container_name   = "weather-webservice"
    container_port   = "50011"
    target_group_arn = aws_alb_target_group.alb_public_50011_target_group.arn
  }
}
