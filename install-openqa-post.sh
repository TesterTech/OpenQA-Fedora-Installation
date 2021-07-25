#!/bin/bash

cd /var/lib/openqa/tests/
git clone https://pagure.io/fedora-qa/os-autoinst-distri-fedora.git fedora
sudo chown -R geekotest:geekotest fedora
cd fedora
sudo ./fifloader.py -l -c templates.fif.json templates-updates.fif.json

git clone https://pagure.io/fedora-qa/createhdds.git /root/createhdds
sudo mkdir -p /var/lib/openqa/factory/hdd/fixed
cd /var/lib/openqa/factory/hdd/fixed
#sudo /root/createhdds/createhdds.py all
sudo chown geekotest *

echo Now clone a job from Fedora Project :-\) 
sudo openqa-clone-job --from https://openqa.fedoraproject.org/tests/929283
sudo systemctl start openqa-worker@1

echo scheduled job should be started by worker!


