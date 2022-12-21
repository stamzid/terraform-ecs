resource "aws_iam_role" "unstructured-ecs-instance-role" {
  name = "unstructured-ecs-instance-role"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.unstructured-ecs-instance-policy.json}"
}

data "aws_iam_policy_document" "unstructured-ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "unstructured-ecs-instance-role-attachment" {
   role = "${aws_iam_role.unstructured-ecs-instance-role.name}"
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "unstructured-ecs-instance-profile" {
  name = "unstructured-ecs-instance-profile"
  path = "/"
  role = "${aws_iam_role.unstructured-ecs-instance-role.id}"
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "aws_iam_role" "unstructured-ecs-task-role" {
  name = "unstructured-ecs-task-role"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.unstructured-ecs-task-policy.json}"
}

resource "aws_iam_role_policy_attachment" "unstructured-ecs-task-role-attachment" {
  role = "${aws_iam_role.unstructured-ecs-task-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "unstructured-ecs-task-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
