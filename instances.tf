resource "aws_key_pair" "demo_ssh_key" {
  key_name = "${var.demo_ssh_key_name}"
  public_key = "${file("${path.cwd}${var.demo_ssh_key_path}")}"
}

data "template_file" "userdata1" {
  template = "${file("${path.cwd}${var.ec2_instance_userdata}")}"
  vars {
    domain_name = "${var.domain_name}"
    hostname = "${var.ec2_instance_host_name}-1"
  }
}

data "template_file" "userdata2" {
  template = "${file("${path.cwd}${var.ec2_instance_userdata}")}"
  vars {
    domain_name = "${var.domain_name}"
    hostname = "${var.ec2_instance_host_name}-2"
  }
}

data "template_file" "userdata3" {
  template = "${file("${path.cwd}${var.ec2_instance_userdata}")}"
  vars {
    domain_name = "${var.domain_name}"
    hostname = "${var.ec2_instance_host_name}-3"
  }
}

resource "aws_instance" "server1" {
  user_data = "${data.template_file.userdata1.rendered}"
  tags {
    Name = "${var.ec2_instance_host_name}-1",
  }
  instance_type = "${var.ec2_instance_instance_type}"
  key_name = "${aws_key_pair.demo_ssh_key.key_name}"
  ami = "${var.ec2_instance_ami}"
  vpc_security_group_ids = [
      "${aws_security_group.all_local_traffic.id}",
      "${aws_security_group.my_public_ip.id}"
      ]
  subnet_id = "${aws_subnet.demo_subnet.id}"
  root_block_device = {
    volume_size = "${var.ec2_instance_root_block_dev_size}",
    volume_type = "${var.ec2_instance_root_block_dev_type}"
    }
}

resource "aws_instance" "server2" {
  user_data = "${data.template_file.userdata2.rendered}"
  tags {
    Name = "${var.ec2_instance_host_name}-2",
  }
  instance_type = "${var.ec2_instance_instance_type}"
  key_name = "${aws_key_pair.demo_ssh_key.key_name}"
  ami = "${var.ec2_instance_ami}"
  vpc_security_group_ids = [
      "${aws_security_group.all_local_traffic.id}",
      "${aws_security_group.my_public_ip.id}"
      ]
  subnet_id = "${aws_subnet.demo_subnet_b.id}"
  root_block_device = {
    volume_size = "${var.ec2_instance_root_block_dev_size}",
    volume_type = "${var.ec2_instance_root_block_dev_type}"
    }
}

resource "aws_instance" "server3" {
  user_data = "${data.template_file.userdata3.rendered}"
  tags {
    Name = "${var.ec2_instance_host_name}-3",
  }
  instance_type = "${var.ec2_instance_instance_type}"
  key_name = "${aws_key_pair.demo_ssh_key.key_name}"
  ami = "${var.ec2_instance_ami}"
  vpc_security_group_ids = [
      "${aws_security_group.all_local_traffic.id}",
      "${aws_security_group.my_public_ip.id}"
      ]
  subnet_id = "${aws_subnet.demo_subnet.id}"
  root_block_device = {
    volume_size = "${var.ec2_instance_root_block_dev_size}",
    volume_type = "${var.ec2_instance_root_block_dev_type}"
    }
}

resource "aws_route53_record" "server1" {
  zone_id = "${var.r53_zone_id}"
  name = "${var.ec2_instance_host_name}-1.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.server1.private_ip}"]
}

resource "aws_route53_record" "server2" {
  zone_id = "${var.r53_zone_id}"
  name = "${var.ec2_instance_host_name}-2.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.server2.private_ip}"]
}

resource "aws_route53_record" "server3" {
  zone_id = "${var.r53_zone_id}"
  name = "${var.ec2_instance_host_name}-3.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.server3.private_ip}"]
}


