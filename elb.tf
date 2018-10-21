# You may not need this LB setup. Its original purpose is for a Rancher cluster.
# The folowing resources setup the network load balancer (layer 4) to your instances on 80 and 443. This project was originally created for a Rancher cluster so that's why this is here. 

resource "aws_route53_record" "server-elb" {
  zone_id = "${var.r53_zone_id}"
  name = "demo-elb-host"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.demo_elb.dns_name}"]
}

resource "aws_lb_target_group" "server_server_https" {
  name     = "server1-https"
  port     = 443
  protocol = "TCP"
  target_type = "ip"
  deregistration_delay = 20
  vpc_id   = "${aws_vpc.demo_vpc.id}"
  health_check = {
    interval = 10
    path = "/healthz"
    port = 80
    protocol = "HTTP"
    timeout = 6
    healthy_threshold = 3
    unhealthy_threshold = 3
    matcher = "200-399"
  }
}

resource "aws_lb_target_group_attachment" "server1-1" {
  target_group_arn = "${aws_lb_target_group.server_server_https.arn}"
  target_id        = "${aws_instance.server1.private_ip}"
}
resource "aws_lb_target_group_attachment" "server1-2" {
  target_group_arn = "${aws_lb_target_group.server_server_https.arn}"
  target_id        = "${aws_instance.server2.private_ip}"
}
resource "aws_lb_target_group_attachment" "server1-3" {
  target_group_arn = "${aws_lb_target_group.server_server_https.arn}"
  target_id        = "${aws_instance.server3.private_ip}"
}

resource "aws_lb_target_group" "server_server_http" {
  name     = "server1-http"
  port     = 80
  protocol = "TCP"
  target_type = "ip"
  deregistration_delay = 20
  vpc_id   = "${aws_vpc.demo_vpc.id}"
  health_check = {
    interval = 10
    path = "/healthz"
    port = 80
    protocol = "HTTP"
    timeout = 6
    healthy_threshold = 3
    unhealthy_threshold = 3
    matcher = "200-399"
  }
}
resource "aws_lb_target_group_attachment" "server1-http-1" {
  target_group_arn = "${aws_lb_target_group.server_server_http.arn}"
  target_id        = "${aws_instance.server1.private_ip}"
}
resource "aws_lb_target_group_attachment" "server1-http-2" {
  target_group_arn = "${aws_lb_target_group.server_server_http.arn}"
  target_id        = "${aws_instance.server2.private_ip}"
}
resource "aws_lb_target_group_attachment" "server1-http-3" {
  target_group_arn = "${aws_lb_target_group.server_server_http.arn}"
  target_id        = "${aws_instance.server3.private_ip}"
}

resource "aws_lb_listener" "elb-https" {
  load_balancer_arn = "${aws_lb.demo_elb.arn}"
  port              = "443"
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.server_server_https.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "elb-http" {
  load_balancer_arn = "${aws_lb.demo_elb.arn}"
  port              = "80"
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.server_server_http.arn}"
    type             = "forward"
  }
}

resource "aws_lb" "demo_elb" {
  load_balancer_type = "network"
  name            = "${var.demo_elb_name}"
  internal        = false
  subnets         = [
    "${aws_subnet.demo_subnet.id}",
    "${aws_subnet.demo_subnet_b.id}",
    ]
  enable_deletion_protection = false
  tags {
    Name = "${var.demo_elb_name}"
  }
}

