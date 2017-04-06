define wordpress (
  String $id = $title,
  String $site_title = 'My Blog',
  String $domain,
  String $root_password,
  String $db_password,
  Boolean $ssl = false,
)

{
  $db_name = "wp_${id}"

  $web_root = '/var/www/html';
  $wp_root = "$web_root/wordpress";

  user { 'wp':
    ensure => present,
    home => '/home/wp',
    shell => '/usr/bin/zsh',
    groups => 'www-data',
  }

  ## Wordpress Install
  ## =================

  file { $wp_root:
    ensure => directory,
    recurse => true,
    owner => 'wp',
    group => 'www-data',
    mode => '0664',
    source => 'puppet:///modules/wordpress/wordpress',
  }

  $wp_config_params = { db_name => $db_name
                      , db_user => $db_name
                      , db_password => $db_password
                      , table_prefix => $id
                      }

  file { "$wp_root/wp-config.php":
    ensure => file,
    content => epp('wordpress/wp-config.php', $wp_config_params),
    owner => 'wp',
    group => 'www-data',
    require => File[$wp_root],
    notify => Service['apache2'],
  }

  file { "$wp_root/.htaccess":
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => 'puppet:///modules/wordpress/htaccess',
  }

  file { "$wp_root/wp-content/themes/portland-dsa":
    ensure => directory,
    recurse => true,
    owner => 'wp',
    group => 'www-data',
    mode => '0664',
    source => 'puppet:///modules/wordpress/dsa-wp-theme',
  }

  ## Apache Config
  ## =============

  $apache_params = {domain => $domain}
  if $ssl {
    $apache_conf = epp('wordpress/apache-site-ssl.conf', $apache_params)
  } else {
    $apache_conf = epp('wordpress/apache-site.conf', $apache_params)
  }

  file { "/etc/apache2/sites-available/${id}.conf":
    ensure => file,
    content => $apache_conf,
    owner => 'root',
    group => 'root',
    mode => '0644',
    require => [ Package['apache2']
               , File[$wp_root]
               ],
    notify => Service['apache2']
  }

  file { "/etc/apache2/sites-enabled/${id}.conf":
    ensure => link,
    target => "/etc/apache2/sites-available/${id}.conf",
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure => absent,
  }

  exec { 'enable-apache2-modules':
    command => '/usr/sbin/a2enmod rewrite ssl php7.0',
    user => 'root',
    refreshonly => true,
    notify => Service['apache2'],
    subscribe => [ Package['apache2']
                 , Package['libapache2-mod-php']
                 , File["/etc/apache2/sites-enabled/${id}.conf"]
                 , File[$wp_root]
                 ],
  }

  ## MySQL Server
  ## ============

  class { '::mysql::server':
    root_password => $root_password,
    remove_default_accounts => true,
  }

  class { '::mysql::bindings':
    php_enable => true,
  }

  mysql::db { "${db_name}":
    user => $db_name,
    password => $db_password,
    dbname => $db_name,
    host => 'localhost',
  }

  class { '::mysql::server::backup':
    backupdatabases =>  [$db_name],
    file_per_database => true,
    include_triggers => true,
    include_routines => true,
    time => [15, 46],

    backupuser => "wp_backup",
    backuppassword => $db_password,
    backupdir => "/var/backups/${db_name}",
    backupdirmode => "0700",
    backuprotate => 90,
  }

  ## Required Packages & Services
  ## ============================

  ensure_packages([ 'apache2'
                  , 'lib32z1'
                  , 'php'
                  , 'php-ssh2'
                  , 'libapache2-mod-php'
                  , 'unzip'
                  , 'tar'
                  ])

  service { 'apache2':
    ensure => running,
    require => Package['apache2'],
  }


  ## Come on, really?
  ## ================

  file { 'wp-home':
    ensure => directory,
    path => '/home/wp',
    owner => 'wp',
    group => 'wp',
    mode => '0700',
    require => User['wp'],
  }

}
