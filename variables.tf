variable "bc-cidr-block" {
  default = "10.30.0.0/16"
}

variable "subnets_cidr" {
  type    = "list"
  default = ["10.30.1.0/24", "10.30.2.0/24"]
}

variable "subnet_zone" {
  type    = "list"
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "aws-zone" {
  default = "eu-west-2"
}

variable "fargate_cpu" {
  default = 256
}

variable "fargate_memory" {
  default = 512
}

variable "app_image" {
  default = "owner_id.dkr.ecr.eu-west-2.amazonaws.com/test-app:latest"
}

variable "app_port" {
  default = 8000
}
