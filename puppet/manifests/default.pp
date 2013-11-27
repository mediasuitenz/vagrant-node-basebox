# Puppet tools
package { 'librarian-puppet':
    ensure   => 'installed',
    provider => 'gem',
}

# Version control
include git

# Editors
package { "vim":
  ensure => present,
}

package { "curl":
  ensure => present,
}

# Install nodejs
class { 'nodejs':
  version => 'v0.10.22'
}
->
exec { 'add nodemodules to path':
  command => '/bin/bash -c \'echo "export PATH=$PATH:/usr/local/node/node-v0.10.22/bin" >> /home/vagrant/.bashrc\'',
}

# Install grunt globally
package { 'grunt-cli':
  provider => npm
}

# Requirement for phantomjs
package { 'fontconfig':
  ensure => latest
}

class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.2',
}->
class { 'postgresql::server':
  postgres_password => 'password',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses           => '*',
}
->
class { 'postgis':}

postgresql::server::db { 'development':
  user     => 'user',
  password => postgresql_password('user', 'password'),
}

postgresql::server::role { "user":
  password_hash => postgresql_password('user', 'password'),
  superuser => true,
}
