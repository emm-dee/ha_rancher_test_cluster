#!/bin/bash
sudo echo "setting hostname" >> /root/cloud-init.log
sudo hostname ${hostname}.${domain_name}
sudo echo 127.0.1.1 >> ${hostname}.${domain_name}
sudo echo ${hostname}.${domain_name} > /etc/hostname
sudo echo "setting tz" >> /root/cloud-init.log
sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata
sudo echo "apt-get update" >> /root/cloud-init.log
sudo apt-get update
sudo echo "installing apt packages" >> /root/cloud-init.log
sudo su -c "DEBIAN_FRONTEND=noninteractive apt-get -yq install tshark"
sudo apt-get -y install htop lsof iftop iotop nmap nfs-common cifs-utils traceroute python-pip nagios-nrpe-server nagios-plugins sshpass
sudo echo "setting vm.max_map_count for docker" >> /root/cloud-init.log
sudo bash -c "echo vm.max_map_count=262144 >> /etc/sysctl.conf"
sudo sysctl -w vm.max_map_count=262144
sudo apt-get update
sudo echo "installing more apt packages (why separate? I forget)" >> /root/cloud-init.log
x="$(uname -r)"
x="$(echo $x | sed 's/\-aws//g')"
sudo apt-get install -y \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common 

###
sudo echo "adding docker gpg key to apt-key" >> /root/cloud-init.log
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo echo "adding docker repo" >> /root/cloud-init.log
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo echo "apt update again" >> /root/cloud-init.log
sudo apt-get update
sudo echo "install docker 17.03.02" >> /root/cloud-init.log
sudo apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial
sudo echo "lock docker version" >> /root/cloud-init.log
sudo echo "docker-ce hold" | sudo dpkg --set-selections
sudo useradd -u 999 -g docker -s /bin/bash docker
sleep 10
sudo echo "install docker-compose" >> /root/cloud-init.log
sudo apt-get install -y docker-compose
#sudo docker pull jenkins/jenkins:lts
sudo echo "add ubuntu to docker grp" >> /root/cloud-init.log
sudo usermod -aG docker ubuntu
sudo echo "disable swap" >> /root/cloud-init.log
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo echo "cloud-init complete" >> /root/cloud-init.log