class ubuntu {
  cron { 'update-apt':
    command => '/usr/bin/apt-get update',
    user => 'root',
    hour => 8,
    minute => 0,
  }

  exec { 'init-apt-and-puppet':
    command => '/bin/sh < /tmp/init-apt-and-puppet.sh && touch /opt/apt-inited',
    creates => '/opt/apt-inited',
    require => File['/tmp/init-apt-and-puppet.sh'],
  }

  file { '/tmp/init-apt-and-puppet.sh':
    ensure => file,
    mode => '0774',
    owner => 'root',
    group => 'root',
    source => 'puppet:///modules/ubuntu/add-pl-repo.sh',
  }
}
