class nginx {
  package { 'nginx':
    ensure => present,
  }

  file {
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { ['/var/www/', '/etc/nginx/conf.d/']:
    ensure  => directory,
    require => Package['nginx'],
  }
  file { '/var/www/index.html':
    ensure  => file,
    source  => 'puppet:///modules/nginx/index.html',
    require => File['/var/www/'],
  }
  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/conf.d/default.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  service {'nginx':
    ensure => running,
    enable => true,
  }

}
