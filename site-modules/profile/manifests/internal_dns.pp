# Sets up hosts file to resolve internal services
class profile::internal_dns {
  host { 'NAS':
    name => 'nas.pitlor.local',
    ip   => '10.1.0.7',
  }

  host { 'Nginx Proxy Manager':
    name => 'proxy.pitlor.local',
    ip   => '10.1.0.7',
  }

  host { 'Proxmox':
    name => 'proxmox.pitlor.local',
    ip   => '10.1.0.7',
  }

  host { 'Portainer':
    name => 'portainer.pitlor.local',
    ip   => '10.1.0.7',
  }
}
