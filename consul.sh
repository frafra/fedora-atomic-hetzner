#!/bin/bash

set -ex -o pipefail

ip=$1
first=$2
nodes=$3
datacenter=$4
quorum=$(((1+$nodes)/2))

user="consul"
adduser $user

sudo -u $user mkdir /home/$user/data
sudo -u $user podman pull --quiet consul
sudo -u $user podman container create \
  --volume /home/$user/data:/consul/data:Z \
  --net=host \
  --name consul \
  consul agent \
    -server \
    -bind=$ip \
    -retry-join=$first \
    -bootstrap-expect=$quorum \
    -datacenter=$datacenter

cat << EOF > /etc/systemd/system/consul.service
[Unit]
Description=Consul container

[Service]
Restart=on-failure
ExecStart=/usr/bin/podman start --attach consul
ExecStop=/usr/bin/podman stop --timeout 3 consul
User=$user
Group=$user

[Install]
WantedBy=multi-user.target
EOF

systemctl start consul
systemctl enable consul

