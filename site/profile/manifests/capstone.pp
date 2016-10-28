# profile/manifests/capstone.pp

class profile::capstone {
  # Or use hiera calls
  $wp_docroot = '/var/www/html'
  $wp_vhost = 'wordpress.puppetlabs.vm'
  $wp_port = '80'

  # Manage apache
  class { 'apache':
    port          => $wp_port,
    docroot       => $wp_docroot,
  }
  include ::apache::mod::php

  # Manage mysql
  include ::mysql::server
  # After installing php bindings Apache needs to be restarted
  class { '::mysql::bindings':
    php_enable => true,
    notify     => Service['httpd'],
  }

  # Manage wordpress
  class { '::wordpress':
    install_dir => $wp_docroot,
  }
}
