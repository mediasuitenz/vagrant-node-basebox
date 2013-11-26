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
