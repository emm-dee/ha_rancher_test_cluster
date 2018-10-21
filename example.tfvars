# Change these...
access_key = "access key goes here"
secret_key = "secret key goes here"
r53_zone_id = "your zone id goes here"
domain_name = "your.desired.domain.name"

# Region, change if needed...
region = "us-east-1"

# AMI here is Ubuntu 16.04 in us-east region... Change if needed...
ec2_instance_ami = "ami-059eeca93cf09eebd"

# The public CIDR IP of your workstation so you can connect to the instances public address. Be sure to include the /32 since this will be used for a security group rule. 
# Browse or curl to icanhazip.com to get the needed value :)
my_cidr = "8.8.8.8/32"

# VPC Network config. Change if you need to or leave it as-is if it doesn't conflict with your existing setup:
vpc_cidr = "10.10.0.0/16"
subnet_cidr = "10.10.10.0/24"
subnet_cidr_b = "10.10.11.0/24"

# Relative path to the public key you'll use to ssh with. Generate your keys first so that you can ssh into the instances. 
# Yes, the prepended / slash is needed even though it's a relative path, sue me for writing bad resources. 
demo_ssh_key_path = "/keys/ssh.pub"

# Relative path to the userdata script. There is already one created for you (check the project readme). Change if needed.
# Yes, the prepended / slash is needed even though it's a relative path, sue me for writing bad resources. 
ec2_instance_userdata = "/userdata/demo_userdata.sh"

# You don't really need to change the rest of this unless it conflicts with your existing setup or whatever...
vpc_name = "test_demo_vpc"
subnet_name = "test_demo_subnet"
subnet_name_b = "test_demo_subnet_b"
demo_dhcp_opts_name = "test_demo_dhcpopts"
demo_elb_name = "test-demo-elb"
demo_ssh_key_name = "test_ssh_demo"
ec2_instance_host_name = "test-tf-inst"

# Instance info, change if needed...
ec2_instance_instance_type = "t2.medium"
ec2_instance_root_block_dev_size = "12"
ec2_instance_root_block_dev_type = "standard"