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
  user     => 'user',
  password => postgresql_password('user', 'password'),
}

postgresql::server::role { "user":
  password_hash => postgresql_password('user', 'password'),
  superuser => true,
}

class { 'mongodb': }

mongodb::user { 'user':
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
mysql_user { 'user@localhost':
  ensure                   => 'present',
  max_connections_per_hour => '0',
  max_queries_per_hour     => '0',
  max_updates_per_hour     => '0',
  max_user_connections     => '0',
  password_hash            => '*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19',
}
->
mysql_grant { 'user@localhost/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'user@localhost',
}
->
mysql_grant { 'user@%/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'user@%',
}

mysql::db { 'development':
  user     => 'user',
  password => 'password',
  host     => '%',
  grant    => ['ALL '],
}

mysql::db { 'production':
  user     => 'user',
  password => 'password',
  host     => '%',
  grant    => ['ALL'],
}

mysql::db { 'testing':
  user     => 'user',
  password => 'password',
  host     => '%',
  grant    => ['ALL'],
}
