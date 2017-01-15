define nginx_static (
  String $serve_dir,
  String $domain,
)

{
  ensure_packages('nginx')

  $conf_file =  "/etc/nginx/sites-available/${title}";
  $enable_link = "/etc/nginx/sites-enabled/${title}";

  file { $conf_file:
    ensure => file,
    content => epp('nginx_static/static-site', {server_name => $domain, web_root => $serve_dir}),
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
