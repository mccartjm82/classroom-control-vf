# nginx/manifests/init.pp
class nginx (
  $docroot = $nginx::params::docroot,
  $logsdir = $nginx::params::logsdir,
  $confdir = $nginx::params::confdir,
  $blckdir = $nginx::params::blckdir,
  $pkgname = $nginx::params::pkgname,
  $fileown = $nginx::params::fileown,
  $filegrp = $nginx::params::filegrp,
  $svcname = $nginx::params::svcname,
  $svcuser = $nginx::params::svcuser,
) inherits nginx::params {

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
