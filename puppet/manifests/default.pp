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

# Java
package { 'openjdk-7-jre-headless':
  ensure => present
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

# Databases

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
  user     => 'username',
  password => postgresql_password('username', 'password'),
}

postgresql::server::db { 'production':
  user     => 'username',
  password => postgresql_password('username', 'password'),
}

postgresql::server::db { 'testing':
  user     => 'username',
  password => postgresql_password('username', 'password'),
}

postgresql::server::role { "username":
  password_hash => postgresql_password('username', 'password'),
  superuser => true,
}

class { 'mongodb': }

mongodb::user { 'username':
  password => 'password',
}

class {'mysql::server':
  root_password => 'password',
  override_options => {
    mysqld => {
      bind_address => '0.0.0.0',
      "skip-external-locking" => "false",
    }
  }
}
->
mysql_user { 'username@localhost':
  ensure                   => 'present',
  max_connections_per_hour => '0',
  max_queries_per_hour     => '0',
  max_updates_per_hour     => '0',
  max_user_connections     => '0',
  password_hash            => '*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19',
}
->
mysql_grant { 'username@localhost/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'username@localhost',
}
->
mysql_grant { 'username@%/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'username@%',
}

mysql::db { 'development':
  user     => 'username',
  password => 'password',
  host     => '%',
  grant    => ['ALL '],
}

mysql::db { 'production':
  user     => 'username',
  password => 'password',
  host     => '%',
  grant    => ['ALL'],
}

mysql::db { 'testing':
  user     => 'username',
  password => 'password',
  host     => '%',
  grant    => ['ALL'],
}

# module installed via
# https://forge.puppetlabs.com/fsalum/redis
# with the commands
# v ssh
# puppet module install --modulepath /vagrant/puppet/modules fsalum/redis
class { 'redis':
  conf_port => '6379',
  conf_bind => '0.0.0.0',
}
