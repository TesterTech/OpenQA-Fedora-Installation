#!/bin/bash


# Test scrip based on installation guide from Fedora:
# https://fedoraproject.org/wiki/OpenQA_direct_installation_guide
export release=$(uname -a)
echo Installing OpenQA on Fedora 
echo Running on: $release

#sudo dnf update -y 
sudo dnf install -y git vim openssh-server openqa openqa-httpd openqa-worker fedora-messaging libguestfs-tools libguestfs-xfs python3-fedfind python3-libguestfs libvirt-daemon-config-network libvirt-python3 virt-install withlock postgresql-server fedora-messaging

cd /etc/httpd/conf.d/
sudo cp openqa.conf.template openqa.conf
sudo cp openqa-ssl.conf.template openqa-ssl.conf

sudo cat << EOF >  /etc/openqa/openqa.ini 
[global]
branding=plain
download_domains = fedoraproject.org
[auth]
method = Fake
EOF

postgresql-setup --initdb

sudo systemctl start sshd
sudo systemctl start postgresql
sudo systemctl start httpd
sudo systemctl start openqa-gru
sudo systemctl start openqa-scheduler
sudo systemctl start openqa-websockets
sudo systemctl start openqa-webui
sudo systemctl start fm-consumer@fedora_openqa_scheduler
sudo systemctl enable postgresql
sudo systemctl enable httpd
sudo systemctl enable openqa-gru
sudo systemctl enable openqa-scheduler
sudo systemctl enable openqa-websockets
sudo systemctl enable openqa-webui
sudo systemctl enable fm-consumer@fedora_openqa_scheduler
sudo systemctl enable sshd

sudo firewall-cmd --add-port=80/tcp
sudo firewall-cmd --runtime-to-permanent
sudo setsebool -P httpd_can_network_connect 1
sudo systemctl restart httpd

echo Note! the api key will expire in one day after installation!

sudo cat << EOF >  /etc/openqa/client.conf 
[localhost]
key = 1234567890ABCDEF 
secret = 1234567890ABCDEF 
EOF

echo "Done, preparations. Now log in one time! Then run sudo ./install-openqa-post.sh"



