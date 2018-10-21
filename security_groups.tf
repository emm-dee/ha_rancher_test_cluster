resource "aws_security_group" "https_public" {
  name        = "https_public"
  description = "https_public"
  vpc_id      = "${aws_vpc.demo_vpc.id}"
  tags {
    Name = "https_public"
  }
  ingress {
    description = "https_public"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }
}

resource "aws_security_group" "all_local_traffic" {
  name        = "all_local_traffic"
  description = "all_local_traffic"
  vpc_id      = "${aws_vpc.demo_vpc.id}"
  tags {
    Name = "all_local_traffic"
  }
  ingress {
    description = "all_local_traffic"
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }
}

resource "aws_security_group" "my_public_ip" {
  name        = "my_public_ip"
  description = "my_public_ip"
  vpc_id      = "${aws_vpc.demo_vpc.id}"
  tags {
    Name = "my_public_ip"
  }
  ingress {
    description = "my_public_ip"
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["${var.my_cidr}"]
  }
  egress {
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }
}
