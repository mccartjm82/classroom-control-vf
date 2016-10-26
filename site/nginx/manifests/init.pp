class nginx {
  package { 'nginx':
    ensure => present,
  }
  
  file { '/var/www/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => Package['nginx'],
  }
  file { '/var/www/index.html':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    source  => 'puppet:///modules/nginx/index.html',
    require => File['/var/www/'],
  }
  file { '/etc/nginx/nginx.conf': 
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  file { '/etc/nginx/conf.d/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => Package['nginx'],
  }
  file { '/etc/nginx/conf.d/default.conf': 
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  
  service {'nginx':
    ensure => running,
    enable => true,
  }

}