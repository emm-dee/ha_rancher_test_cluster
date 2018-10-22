#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: ./rkecluster.sh <path_to_ssh_key>"
    echo "Example: ./rkecluster.sh /Users/myuser/keys/sshkey.pem"
    exit 1
fi

echo ""
echo "This tool is EXTREMELY DESTRUCTIVE -- Use at your own risk"
echo ""
echo "This tool will do the following, with no remorse:"
echo ""
echo "--- FORCED TERRAFORM \"DESTROY\" AND \"APPLY\" ACTIONS TO THE TERRAFORM STATE IN THE CURRENT DIR ---"
echo "---"
echo "--- Run \"rm -f kube_config_rkecluster.yml\" in the current directory ---"
echo "---"
echo "--- I'LL USE THE FOLLOWING SSH KEY: ${1} ---"
echo ""
read -p "You're SURE about proceeding? (y/n) -- do not proceed unless you're certain: " selection
if [[ $selection != "y" ]];
then
echo "exiting"
exit 3
fi

if ! [[ -x "$(command -v terraform)" || -x "$(command -v rke)" ]]; then
echo "Error: terraform or rke not installed under the commands: terraform, rke"
exit 1
fi


rm -f kube_config_rkecluster.yml || true

terraform init
terraform destroy -auto-approve=true
terraform apply -auto-approve=true

echo "Docker needs to be up and running on the hosts. We're waiting 90 seconds to ensure the install has taken place and we're good to go."
sleep 90

elbhost=$(terraform output elb_full_domain_name)
serverone=$(terraform output server1_ext_ip)
servertwo=$(terraform output server2_ext_ip)
serverthree=$(terraform output server3_ext_ip)
serveroneint=$(terraform output server1_int_ip)
servertwoint=$(terraform output server2_int_ip)
serverthreeint=$(terraform output server3_int_ip)

cat > rkecluster.yml <<EOL
nodes:
  - address: ${serverone}
    internal_address: ${serveroneint}
    user: ubuntu
    role: [controlplane,worker,etcd]
    ssh_key_path: ${1}
  - address: ${servertwo}
    internal_address: ${servertwoint}
    user: ubuntu
    role: [controlplane,worker,etcd]
    ssh_key_path: ${1}
  - address: ${serverthree}
    internal_address: ${serverthreeint}
    user: ubuntu
    role: [controlplane,worker,etcd]
    ssh_key_path: ${1}
EOL

#read -p "Enter the EXACT hostname of the rancher cluster endpoint (probably your elb hostname): " selection
echo "Running rke up"
rke up --config rkecluster.yml
export KUBECONFIG="${PWD}/kube_config_rkecluster.yml"
sleep 5
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm --kubeconfig "${PWD}/kube_config_rkecluster.yml" init --service-account tiller
echo "Waiting 10 secs for tiller"
sleep 10
kubectl get po --all-namespaces
helm --kubeconfig "${PWD}/kube_config_rkecluster.yml" repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm --kubeconfig "${PWD}/kube_config_rkecluster.yml" install stable/cert-manager --name cert-manager --namespace kube-system
sleep 5
echo "Installing Rancher..."
helm --kubeconfig "${PWD}/kube_config_rkecluster.yml" install rancher-stable/rancher --name rancher --namespace cattle-system --set hostname="${elbhost}"
kubectl get po --all-namespaces
echo ""
echo "All done! Wait a bit, then navigate to https://${elbhost} and (hopefully) you're good to go!"
echo "It may take between 1-3 minutes for everything to be started."
echo ""
