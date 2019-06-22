resource "aws_vpc" "vpc-test" {
  cidr_block = "${var.bc-cidr-block}"

  tags = {
    Name = "BC Fargate"
  }
}

#### internet gateway
resource "aws_internet_gateway" "vpc-test-igw" {
  vpc_id = "${aws_vpc.vpc-test.id}"

  tags = {
    Name = "VPC Test IGW"
  }
}

#### subnets
resource "aws_subnet" "public_subnet" {
  count             = "${length(var.subnets_cidr)}"
  vpc_id            = "${aws_vpc.vpc-test.id}"
  availability_zone = "${element(var.subnet_zone, count.index)}"
  cidr_block        = "${element(var.subnets_cidr, count.index)}"

  tags = {
    Name = "Public subnet-${count.index + 1}"
  }
}

####route table

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc-test.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc-test-igw.id}"
  }

  tags = {
    Name = "Route table public"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = "${length(var.subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
