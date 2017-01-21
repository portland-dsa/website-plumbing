define nginx_static (
  String $serve_dir,
  String $domain,
  Boolean $ssl = false,
  Optional[String] $long_domain = undef,
)

{
  ensure_packages('nginx')

  $conf_file =  "/etc/nginx/sites-available/${title}";
  $enable_link = "/etc/nginx/sites-enabled/${title}";

  if $long_domain {
    $_long_domain = $long_domain
  } else {
    $_long_domain = $domain
  }

  if $ssl {
    $content = epp('nginx_static/static-site-ssl',
                  { domain => $domain
                  , domain_www => $_long_domain
                  , web_root => $serve_dir
                  })
  } else {
    $content = epp('nginx_static/static-site',
                  { domain => $domain
                  , domain_www => $_long_domain
                  , web_root => $serve_dir
                  })
  }

  file { $conf_file:
    ensure => file,
    content => $content,
    owner => 'root',
    group => 'root',
    mode => '0644',
    require => Package['nginx'],
  }

  file { $enable_link:
    ensure => link,
    target => "/etc/nginx/sites-available/${title}",
    owner => 'root',
    group => 'root',
    mode => '0644',
    require => Package['nginx'],
  }

  file { "/etc/nginx/sites-enabled/default":
    ensure => absent,
  }

  service { 'nginx':
    ensure => running,
    hasrestart => true,
    subscribe => File[$conf_file],
  }

}
