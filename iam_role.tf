resource "aws_iam_role" "ecs_role" {
  name               = "testapp-ecs-role"
  path               = "/"
  assume_role_policy = "${file("./roles/ecs_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "esc_role_policy" {
  role       = "${aws_iam_role.ecs_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "autoscaling_role" {
  name               = "testapp-as-role"
  path               = "/"
  assume_role_policy = "${file("./roles/auto_scaling_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "autoscaling_role_policy" {
  role       = "${aws_iam_role.autoscaling_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}
