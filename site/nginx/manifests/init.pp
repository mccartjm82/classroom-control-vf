# nginx/manifests/init.pp
class nginx ($root = undef,){

  case $::osfamily{
    'redhat','debian':{
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      #$docroot = '/var/www'
      $confdir = '/etc/nginx'
      $logdir = '/var/log/nginx'
    }
    'windows':{
      $package = 'nginx-service'
      $owner = 'administrator'
      $group = 'administrator'
      #$docroot = 'C:/ProgramData/nginx/html'
      $confdir = 'C:/ProgramData/nginx'
      $logdir = 'C:/ProgramData/nginx/logs'
    }
    default :{
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }

  $user = $::osfamily ? {
    'redhat' => 'nginx',
    'debian' => 'www-data',
    'windows' => 'nobody',
  }

  $docroot = $root ?{
    undef => $default_docroot,
    default => $root,
  }

  File {
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => '0644',
  }

  package { $package:
    ensure => present,
  }

  file { [$docroot,"${confdir}/conf.d"]:
    ensure => directory,
  }

  file { "${docroot}/index.html":
    source => 'puppet:///modules/nginx/index.html',
  }

  file { "${confdir}/nginx.conf":
    content => epp('nginx/nginx.conf.epp',
      {
        user => $user,
        confdir => $confdir,
        logdir => $logdir,
        }),
    notify => Service['nginx'],
}

  file { "${confdir}/conf.d/default.conf":
    content => epp('nginx/default.conf.epp',
      {
        docroot => $docroot,
      }),
    notify => Service['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
  }
}
