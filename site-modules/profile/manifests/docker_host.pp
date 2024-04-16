# Use homelab-containers repository to deploy docker containers
class profile::docker_host {
  include 'docker'

  class {'docker::compose':
    ensure  => present,
    version => '1.9.0',
  }

  package { 'git':
    ensure => installed,
  }

  vcsrepo { '/var/data/dev.pitlor.homelab-containers':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/jpitlor/homelab-containers',
    revision => '$HOMELAB_REPO_COMMIT',
  }

  docker_compose { 'homelab':
    compose_files => ['/var/data/dev.pitlor/homelab-containers/docker-compose.yml'],
    ensure        => present,
  }
}