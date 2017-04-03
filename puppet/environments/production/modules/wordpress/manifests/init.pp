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
  $staging_dir = '/var/cache/puppet-staging';

  user { 'wp':
    ensure => present,
    home => '/home/wp',
    shell => '/usr/bin/zsh',
    groups => 'www-data',
  }

  ## This should go in base puppet module?

  file { $staging_dir:
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0775',
  }

  ## Wordpress Install
  ## =================

  file { "$staging_dir/wp-latest.tar.gz":
    ensure => file,
    source => 'puppet:///modules/wordpress/wordpress.tar.gz',
  }

  exec { 'extract-wordpress':
    cwd => $web_root,
    command => "/bin/tar -xzf $staging_dir/wp-latest.tar.gz",
    refreshonly => true,
    subscribe => File["$staging_dir/wp-latest.tar.gz"],
    require => [ Package['tar']
               , User['wp']
               ],
  }

  file { "$wp_root/wp-content":
    ensure => directory,
    owner => 'wp',
    group => 'www-data',
    mode => '0775',
    require => Exec['extract-wordpress'],
  }

  file { "$wp_root/wp-content/plugins":
    ensure => directory,
    owner => 'wp',
    group => 'www-data',
    mode => '0775',
    require => [ Exec['extract-wordpress']
               , File["$wp_root/wp-content"]
               ]
  }

  file { "$staging_dir/seo-plugin.zip":
    ensure => file,
    source => 'puppet:///modules/wordpress/seo-plugin.zip',
  }

  exec { 'extract-seo-plugin':
    cwd => "$wp_root/wp-content/plugins/",
    command => '/usr/bin/yes y | /usr/bin/unzip $staging_dir/seo-plugin.zip',
    user => 'wp',
    refreshonly => true,
    subscribe => File["$staging_dir/seo-plugin.zip"],
    require => [ Exec['extract-wordpress']
               , File["$wp_root/wp-content"]
               , File["$wp_root/wp-content/plugins"]
               , Package['unzip']
               ]
  }

  file { "$staging_dir/sitemap-plugin.zip":
    ensure => file,
    source => 'puppet:///modules/wordpress/sitemap-generator.zip',
  }

  exec { 'extract-sitemap-plugin':
    cwd => "$wp_root/wp-content/plugins/",
    command => '/usr/bin/yes y | /usr/bin/unzip $staging_dir/sitemap-plugin.zip',
    user => 'wp',
    refreshonly => true,
    subscribe => File["$staging_dir/sitemap-plugin.zip"],
    require => [ Exec['extract-wordpress']
               , File["$wp_root/wp-content"]
               , File["$wp_root/wp-content/plugins"]
               , Package['unzip']
               ]
  }

  file { "$wp_root/wp-content/plugins/functionality":
    ensure => directory,
    owner => 'wp',
    group => 'www-data',
    require => [ File["$wp_root/wp-content"] ],
  }

  file { "$wp_root/wp-content/plugins/functionality/functionality.php":
    ensure => file,
    source => 'puppet:///modules/wordpress/functionality.php',
    owner => 'wp',
    group => 'www-data',
    require => [ Exec['extract-wordpress']
               , File["$wp_root/wp-content/plugins/functionality"]
               ],
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
    require => Exec['extract-wordpress'],
    notify => Service['apache2'],
  }

  file { "$wp_root/.htaccess":
    ensure => file,
    source => 'puppet:///modules/wordpress/htaccess',
    owner => 'root',
    group => 'www-data',
    mode => '0644',
    require => Exec['extract-wordpress'],
  }

  exec { 'wp-permissions-hack':
    cwd => '/var/www/html',
    command => '/bin/chown -R wp:www-data wordpress',
    require => [ Exec['extract-seo-plugin']
               , Exec['extract-sitemap-plugin']
               ]
  }

  exec { 'wp-permissions-hack-2':
    cwd => '/var/www/html',
    command => '/bin/chown -R root:www-data wordpress/.htaccess',
    require => [ Exec['wp-permissions-hack']
               ]
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
               , Exec['extract-wordpress']
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
                 , Exec['extract-wordpress']
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
