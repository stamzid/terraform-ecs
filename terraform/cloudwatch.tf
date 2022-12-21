resource "aws_cloudwatch_log_group" "log_group" {
  name = "unstructured-log-group"
  tags = {
    Environment = "poc"
  }
}
