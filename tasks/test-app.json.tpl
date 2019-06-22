[
  {
    "image": "${app_image}",
    "name": "test_app",
    "networkMode": "awsvpc",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "dockerLabels": {
      "com.datadoghq.ad.instances": "[{\"host\": \"%%host%%\", \"port\": \"${app_port}\"}]",
      "com.datadoghq.ad.check_names": "[\"test_app\"]",
      "com.datadoghq.ad.init_configs": "[{}]"
    }
  }, {
    "name": "datadog-agent",
    "image": "datadog/agent:latest",
    "essential": true,
    "environment": [
      {
        "name": "DD_API_KEY",
        "value": "${datadog_api}"
      },
      {
        "name": "ECS_FARGATE",
        "value": "true"
      }
    ]
  }
]