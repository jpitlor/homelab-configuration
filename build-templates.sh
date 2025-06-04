#!/bin/sh

source .env
ansible-galaxy install -r requirements.yml
pip3 install -r requirements.txt
cd packer
packer build -except='proxmox-clone.*' .
packer build -only='proxmox-clone.*' .