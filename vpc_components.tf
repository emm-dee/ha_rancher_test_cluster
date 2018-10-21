resource "aws_vpc" "demo_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags {
        Name = "${var.vpc_name}"
    }
}

resource "aws_subnet" "demo_subnet" {
  availability_zone       = "${var.region}a"
  vpc_id                  = "${aws_vpc.demo_vpc.id}"
  cidr_block              = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.subnet_name}"
  }
}

resource "aws_subnet" "demo_subnet_b" {
  availability_zone       = "${var.region}b"
  vpc_id                  = "${aws_vpc.demo_vpc.id}"
  cidr_block              = "${var.subnet_cidr_b}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.subnet_name_b}"
  }
}

resource "aws_vpc_dhcp_options" "demo_dhcp_opts" {
  domain_name          = "${var.domain_name}"
  domain_name_servers  = ["AmazonProvidedDNS"]
  tags {
    Name = "${var.demo_dhcp_opts_name}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.demo_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.demo_dhcp_opts.id}"
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = "${aws_vpc.demo_vpc.id}"
}

resource "aws_route_table" "route_inet" {
  vpc_id                  = "${aws_vpc.demo_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw1.id}"
  }
  tags { Name = "Public Route" }
}

resource "aws_route_table_association" "route_inet" {
  subnet_id      = "${aws_subnet.demo_subnet.id}"
  route_table_id = "${aws_route_table.route_inet.id}"
}

resource "aws_route_table_association" "route_inet_b" {
  subnet_id      = "${aws_subnet.demo_subnet_b.id}"
  route_table_id = "${aws_route_table.route_inet.id}"
}