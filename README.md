# Homelab Configuration

Technologies Used: Ansible, Packer 

## Usage

```shell
ansible-galaxy install -r requirements.yml
pip3 install -r requirements.txt
cd packer
packer build -except='proxmox-clone.*' .
packer build -only='proxmox-clone.*' --parallel-builds=1 .
```

## Preparing Proxmox ISO

```shell
sudo apt install proxmox-auto-install-assistant
cd proxmox
wget https://enterprise.proxmox.com/iso/proxmox-ve_8.4-1.iso
proxmox-auto-install-assistant prepare-iso proxmox-ve_8.4-1.iso --fetch-from iso --answer-file ./answers.toml
```