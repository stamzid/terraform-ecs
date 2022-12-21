resource "aws_lb" "loadbalancer" {
  internal            = "false"
  name                = "unstructured-alb"
  subnets             = var.subnets
  security_groups     = [aws_security_group.lb_sg.id]
}


resource "aws_lb_target_group" "lb_target_group" {
  name        = "unstructured-target-group"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    port                = "8080"
    path                = "/"
    protocol            = "HTTP"
    unhealthy_threshold = "3"
  }
}

resource "aws_lb_listener" "lb_listener" {
  default_action {
    target_group_arn = "${aws_lb_target_group.lb_target_group.id}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_lb.loadbalancer.arn}"
  port              = "80"
  protocol          = "HTTP"
}

output "lb_endpoint" {
  value = aws_lb.loadbalancer.dns_name
}
