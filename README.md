# 3 Node Rancher Server cluster (Terraform and rke setup)

This Terraform project will setup a 3 node ec2 instance cluster and use rke to install Kubernetes and Rancher server. 

Do not use this for production, it's to easily create a demo HA cluster and show the steps/components involved. 

It will create the VPC, ssh keys, subnets, route 53, run cloud init, etc.

Nothing fancy here, just straight up infrastructure - quick & easy. 


## Setup / Config:
* You'll need to be using Terraform `v0.11.8` or above. Tested working with `0.11.8`. It needs to be accessible to your shell as the command `terraform`
* You'll need to be using `rke` (version `v0.1.10` used in testing). It needs to be accessible to your shell as the command `rke`
* This project comes with an `example.tfvars` file to show how the variables should be filled in. Easiest way to get it working is to just rename that file to `terraform.tfvars` and **fill in your required values**
* SSH Keys. Generate them using your own method and drop the pub key into the `keys/` directory, you'll want to put your public ssh key in here. Be sure to set the path to the key in the `tfvars` file. 
* Edit the cloud-init if you want to (more info below)
* Regarding route 53 and the zones: The zone should already be setup in R53. Fill in the zone ID and domain name in the tfvars. 


## Cloud Init
Included is a cloud-init file (written as a shell script). You don't need to modify it if you don't want to. Check its contents to see what it does. 

Right now it installs some utilities and docker. The original goal of this cluster was for use with Rancher's `rke` tool so it does config around that.

## Run it:
* Be sure your `terraform.tfvars` is good to go. Read above setup instructions if you haven't done this. 
* Run script as:
```
./rkecluster.sh <path_to_private_key>
```
For example:
```
./rkecluster.sh /Users/myuser/keys/sshkey.pem
```
