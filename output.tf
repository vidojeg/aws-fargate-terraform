output "alb_name" {
  value = "${aws_lb.test_lb.dns_name}"
}

output "aws_repository" {
  value = "${aws_ecr_repository.test-app.repository_url}"
}
