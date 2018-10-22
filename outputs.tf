output "server1_hostname" {
  value = "${var.ec2_instance_host_name}-1"
}
output "server1_int_ip" {
  value = "${aws_instance.server1.private_ip}"
}
output "server1_ext_ip" {
  value = "${aws_instance.server1.public_ip}"
}
output "server2_hostname" {
  value = "${var.ec2_instance_host_name}-2"
}
output "server2_int_ip" {
  value = "${aws_instance.server2.private_ip}"
}
output "server2_ext_ip" {
  value = "${aws_instance.server2.public_ip}"
}
output "server3_hostname" {
  value = "${var.ec2_instance_host_name}-3"
}
output "server3_int_ip" {
  value = "${aws_instance.server3.private_ip}"
}
output "server3_ext_ip" {
  value = "${aws_instance.server3.public_ip}"
}
output "load_balancer_hostname" {
  value = "${aws_lb.demo_elb.dns_name}"
}
output "elb_full_domain_name" {
  value = "${var.demo_elb_name}.${var.domain_name}"
}