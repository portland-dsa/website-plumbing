define custom_user (
  String $username = $title,
  Boolean $admin = false,
  Optional[String] $dotfiles_source = undef,
  Optional[String] $ssh_key = undef,
)

{
  if $admin {
    $groups = "admin"
  } else {
    $groups = []
  }

  user { $username:
    ensure => present,
    home => "/home/$username",
    groups => $groups,
    shell => '/usr/bin/zsh',
    require => Package['zsh'],
  }

  ## Come on, really?
  ## ================

  file { "${username}-home":
    ensure => directory,
    path => "/home/$username",
    owner => $username,
    group => $username,
    mode => '0700',
    require => User[$username],
  }

  if $dotfiles_source {
    $local_dir = "/home/${username}/dotfiles"

    exec { "clone_${username}_dotfiles":
      command => "/usr/bin/git clone ${dotfiles_source} ${local_dir}",
      creates => $local_dir,
      user => $username,
      require => [ Package['git']
                 , User[$username]
                 , File["${username}-home"]
                 ]
    }

    exec { "install_${username}_dotfiles":
      command => "/bin/su -c 'cd ~/dotfiles && ./install.sh' ${username}",
      refreshonly => true,
      require => User[$username],
      subscribe => Exec["clone_${username}_dotfiles"],
    }
  }

  if $ssh_key {
    file { "${username}-ssh-dir":
      ensure => directory,
      path => "/home/${username}/.ssh",
      owner => $username,
      group => $username,
      mode => '0700',
      require => User[$username],
    }

    ssh_authorized_key { $username:
      user => $username,
      type => 'ssh-rsa',
      key => $ssh_key,
      require => File["${username}-ssh-dir"],
    }
  }

  ensure_packages(['zsh', 'git'])
}
