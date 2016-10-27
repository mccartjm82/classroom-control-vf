# nginx/manifests/init.pp
class nginx {

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  package { 'nginx':
    ensure => present,
    before => [File['/etc/nginx/conf.d/default.conf'],File['/etc/nginx/nginx.conf']],
  }

  file { '/var/www':
    ensure => directory,
  }

  file { '/var/www/index.html':
    source => 'puppet:///modules/nginx/index.html',
  }

  file { '/etc/nginx/conf.d/default.conf':
    source  => 'puppet:///modules/nginx/default.conf',
  }

  file { '/etc/nginx/nginx.conf':
    source  => 'puppet:///modules/nginx/nginx.conf',
}

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => [File['/etc/nginx/conf.d/default.conf'],File['/etc/nginx/nginx.conf']],
  }
}
