# Homelab Configurtation

This is an Ansible playbook (and related files) capable of provisioning as many of my 
computers (servers and clients) as is reasonable.

## Usage

While Ansible is typically a "push" model where one commanding server uses SSH to configure
other computers, it's most convenient for me to use a "pull" model where the client computers
download the new configuration and run it themselves. This can be achieved by running:

```shell
sudo apt-get install ansible
ansible-pull -U https://github.com/jpitlor/homelab-configuration
```

Then, to make sure the client stays correctly configured in the future, set up a cron job. This
command writes the cron config to a file in the cron.d folder to make sure any updates to the
cron package don't overwrite this configuration.

```shell
echo "@daily jpitlor ansible-pull -U https://github.com/jpitlor/homelab-configuration" > /etc/cron.d/ansible
```


netsh interface portproxy add v4tov4 listenport=8081 listenaddress=0.0.0.0 connectport=8081 connectaddress=$(wsl hostname -I)
