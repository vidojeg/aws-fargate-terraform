resource "aws_ecs_cluster" "test_cluster" {
  name = "app_test_cluster"
}

data "template_file" "def_task_template" {
  template = "${file("./tasks/test-app.json.tpl")}"

  vars = {
    app_image   = "${var.app_image}"
    app_port    = "${var.app_port}"
    datadog_api = "${jsondecode(aws_secretsmanager_secret_version.datadog_secret_key.secret_string)["datadog_api_key"]}"
  }
}

resource "aws_ecs_task_definition" "app_tasks" {
  family                   = "test_application"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  execution_role_arn       = "${aws_iam_role.ecs_role.arn}"

  container_definitions = "${data.template_file.def_task_template.rendered}"
}

resource "aws_ecs_service" "test_app_service" {
  name            = "app_service"
  cluster         = "${aws_ecs_cluster.test_cluster.id}"
  task_definition = "${aws_ecs_task_definition.app_tasks.arn}"
  launch_type     = "FARGATE"
  desired_count   = 2

  load_balancer {
    container_name   = "test_app"
    container_port   = "${var.app_port}"
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
  }

  network_configuration {
    assign_public_ip = true
    subnets          = aws_subnet.public_subnet.*.id
    security_groups  = ["${aws_security_group.lb_sec_group.id}", "${aws_security_group.app_sec_group.id}"]
  }

  depends_on = ["aws_lb_listener.lb_listener", "aws_iam_role.ecs_role"]
}
