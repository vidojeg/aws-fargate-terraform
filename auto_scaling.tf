resource "aws_appautoscaling_target" "test_app_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.test_cluster.name}/${aws_ecs_service.test_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "${aws_iam_role.autoscaling_role.arn}"
  min_capacity       = 2
  max_capacity       = 5
}

resource "aws_appautoscaling_policy" "policy_up" {
  name               = "test_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.test_cluster.name}/${aws_ecs_service.test_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.test_app_target"]
}

resource "aws_appautoscaling_policy" "policy_down" {
  name               = "test_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.test_cluster.name}/${aws_ecs_service.test_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.test_app_target"]
}

## alarms and alarm triggers

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "test_cpu_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.test_cluster.name}"
    ServiceName = "${aws_ecs_service.test_app_service.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.policy_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "test_cpu_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.test_cluster.name}"
    ServiceName = "${aws_ecs_service.test_app_service.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.policy_down.arn}"]
}
