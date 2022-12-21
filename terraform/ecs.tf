resource "aws_ecs_cluster" "unstructured-cluster" {
  name = "ecs-cluster-for-unstructured"
}

resource "aws_ecs_service" "unstructured-ecs-service" {
  name            = "unstructured-web-app"
  cluster         = aws_ecs_cluster.unstructured-cluster.id
  task_definition = aws_ecs_task_definition.unstructured-task-definition.arn
  launch_type     = "EC2"
  load_balancer {
    container_name       = "unstructured-web-app"
    container_port       = "8080"
    target_group_arn     = "${aws_lb_target_group.lb_target_group.arn}"         # attaching load_balancer target group to ecs
  }

  desired_count = 1
  depends_on = [aws_lb_listener.lb_listener, aws_ecs_task_definition.unstructured-task-definition]
}

resource "aws_ecs_task_definition" "unstructured-task-definition" {
  family                   = "ecs-task-definition-demo"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.unstructured-ecs-task-role.arn
  container_definitions    = jsonencode([
    {
        "name": "unstructured-web-app",
        "image": var.app_image,
        "memory": 2048,
        "cpu": 2,
        "essential": true,
        "entryPoint": ["uvicorn", "web_app.app:app", "--host", "0.0.0.0", "--port", "8080", "--timeout-keep-alive", "0"],
        "portMappings": [
            {
                "containerPort": 8080,
                "hostPort": 8080
            }
        ],
        "environment": [
          {
            "name": "AWS_ACCESS_KEY",
            "value": var.AWS_ACCESS
          },
          {
            "name": "AWS_SECRET_KEY",
            "value": var.AWS_SECRET
          }
        ]
    }
  ])
  depends_on = [aws_instance.ec2_instance]
}
