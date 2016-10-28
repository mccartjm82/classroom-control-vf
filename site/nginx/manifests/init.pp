# nginx/manifests/init.pp
class nginx (
  $root = undef,
) {

  case $::osfamily {
    'RedHat','Debian': {
#      $docroot = '/var/www'
      $logsdir = '/var/log/nginx'
      $confdir = '/etc/nginx'
      $blckdir = '/etc/nginx/conf.d'
      $pkgname = 'nginx'
      $fileown = 'root'
      $filegrp = 'root'
      $svcname = 'nginx'
      $default_docroot = '/var/www'
    }
    'windows': {
#      $docroot = 'C:/ProgramData/nginx/html'
      $logsdir = 'C:/ProgramData/nginx/logs'
      $confdir = 'C:/ProgramData/nginx'
      $blckdir = 'C:/ProgramData/nginx/conf.d'
      $pkgname = 'nginx-service'
      $fileown = 'Administrator'
      $filegrp = 'Administrators'
      $svcname = 'nginx'
      $default_docroot = 'C:/ProgramData/nginx/html'
    }
  }

  $svcuser = $::osfamily ? {
    'RedHat'  => 'nginx',
    'Debian'  => 'www-data',
    'windows' => 'nobody',
  }

  $docroot = $root ? {
    undef   => $default_docroot,
    default => $root,
  }

  File {
    ensure => file,
    owner  => $fileown,
    group  => $filegrp,
    mode   => '0644',
  }

  package { $pkgname:
    ensure => present,
    before => [File["${blckdir}/default.conf"],File["${confdir}/nginx.conf"]],
  }

  file { $docroot:
    ensure => directory,
  }

  file { "${docroot}/index.html":
    source => 'puppet:///modules/nginx/index.html',
  }

  file { "${blckdir}/default.conf":
    content  => epp('nginx/default.conf.epp'),
  }

  file { "${confdir}/nginx.conf":
    content  => epp('nginx/nginx.conf.epp'),
}

  service { $svcname:
    ensure    => running,
    enable    => true,
    subscribe => [File["${blckdir}/default.conf"],File["${confdir}/nginx.conf"]],
  }
}
