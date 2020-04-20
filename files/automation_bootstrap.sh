#!/bin/bash -xe

# output to log file
exec >> /var/log/bootstrap.log 2>&1

echo "metadata_start"

curl -sLO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client=true

yum install -y git
yum update -y

yum install -y squid
sed -i "s/http_access deny all/http_access allow all/g" /etc/squid/squid.conf
systemctl enable squid
systemctl start squid

echo "metadata_end"
