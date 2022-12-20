resource "aws_ecs_cluster" "unstructured-cluster" {
  name = "ecs-cluster-for-unstructured"
}

resource "aws_ecs_service" "unstructured-ecs-service" {
  name            = "web-app"
  cluster         = aws_ecs_cluster.unstructured-cluster.id
  task_definition = aws_ecs_task_definition.unstructured-task-definition.arn
  launch_type     = "EC2"
  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
  }
  desired_count = 1
}

resource "aws_ecs_task_definition" "demo-ecs-task-definition" {
  family                   = "ecs-task-definition-demo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "1024"
  execution_role_arn       = var.execution_role_arn
  container_definitions    = <<EOF
[
  {
    "name": "unstructured-web-app",
    "image": var.app_image,
    "memory": 1024,
    "cpu": 1024,
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ]
  }
]
EOF
}
