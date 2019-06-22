resource "aws_secretsmanager_secret" "datadog_secret" {
  name = "datadog/api/test_key"
}

resource "aws_secretsmanager_secret_version" "datadog_secret_key" {
  secret_id     = "${aws_secretsmanager_secret.datadog_secret.id}"
  secret_string = "${file("./secrets/datadog.json")}"
}