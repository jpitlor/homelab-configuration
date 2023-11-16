# Sets up hosts file to resolve internal services
class profile::internal_dns {
  host { 'NAS':
    name    => 'nas.pitlor.local',
    ip      => '10.1.0.2',
    comment => 'port 5001',
  }

  host { 'Nginx Proxy Manager':
    name    => 'proxy.pitlor.local',
    ip      => '10.1.0.7',
    comment => 'port 81',
  }
}
