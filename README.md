# Homelab Configurtation

Technologies Used: Ansible, Packer 

## Usage

```shell
ansible-galaxy install -r requirements.yml
pip3 install -r requirements.txt
cd packer
packer build -except='proxmox-clone.*' .
packer build -only='proxmox-clone.*' --parallel-builds=1 .
```

netsh interface portproxy add v4tov4 listenport=8081 listenaddress=0.0.0.0 connectport=8081 connectaddress=$(wsl hostname -I)
