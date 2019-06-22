resource "aws_lb" "test_lb" {
  name               = "test-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = "${aws_subnet.public_subnet.*.id}"
  security_groups    = ["${aws_security_group.lb_sec_group.id}"]

  tags = {
    Name = "Test LB"
  }
}

### alb security group
resource "aws_security_group" "lb_sec_group" {
  name   = "ALB security group"
  vpc_id = "${aws_vpc.vpc-test.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = "${aws_lb.test_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_security_group" "app_sec_group" {
  name   = "App security group"
  vpc_id = "${aws_vpc.vpc-test.id}"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#### traget groups
resource "aws_lb_target_group" "lb_target_group" {
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.vpc-test.id}"
  target_type = "ip"
}
