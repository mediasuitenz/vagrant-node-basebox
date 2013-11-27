class postgis {
  package {
    [
      'build-essential',
      'postgresql-server-dev-9.2',
      'libxml2-dev',
      'libproj-dev',
      'libjson0-dev',
      'xsltproc',
      'docbook-xsl',
      'libgdal1-dev',
      'libgdal-dev',
    ]:
  }
  ->
  exec { 'download geos':
    command => '/usr/bin/wget http://download.osgeo.org/geos/geos-3.3.8.tar.bz2',
    creates => '/tmp/geos-3.3.8.tar.bz2',
    cwd => '/tmp',
    # refreshonly => true,
  }
  ->
  exec { 'extract geos':
    command => '/bin/tar xvfj geos-3.3.8.tar.bz2',
    creates => '/tmp/geos-3.3.8',
    cwd => '/tmp',
    # refreshonly => true,
  }
  ->
  exec { 'build and install geos':
    command => '/tmp/geos-3.3.8/configure && /usr/bin/make && /usr/bin/make install',
    cwd => '/tmp/geos-3.3.8',
  }
  ->
  exec { 'download postgis':
    command => '/usr/bin/wget http://download.osgeo.org/postgis/source/postgis-2.0.3.tar.gz',
    creates => '/tmp/postgis-2.0.3.tar.gz',
    cwd => '/tmp',
    # refreshonly => true,
  }
  ->
  exec { 'extract psotgis':
    command => '/bin/tar xfvz postgis-2.0.3.tar.gz',
    creates => '/tmp/postgis-2.0.3',
    cwd => '/tmp',
    # refreshonly => true,
  }
  ->
  exec { 'build and install postgis':
    command => '/tmp/postgis-2.0.3/configure && /usr/bin/make && /usr/bin/make install',
    cwd => '/tmp/postgis-2.0.3',
  }
  ->
  exec {'run ldconfig':
    command => '/sbin/ldconfig'
  }
  ->
  exec {'install postgis comments':
    command => '/usr/bin/make comments-install',
    cwd => '/tmp/postgis-2.0.3',
  }
}


# sudo apt-get install build-essential postgresql-server-dev-9.2 libxml2-dev libproj-dev libjson0-dev xsltproc docbook-xsl libgdal1-dev libgdal-dev

# wget http://download.osgeo.org/geos/geos-3.3.8.tar.bz2
# tar xvfj geos-3.3.8.tar.bz2
# cd geos-3.3.8
# ./configure
# make
# sudo make install

# wget http://download.osgeo.org/postgis/source/postgis-2.0.3.tar.gz
# tar xfvz postgis-2.0.3.tar.gz
# cd postgis-2.0.3
# ./configure
# make
# sudo apt-get install
# make
# sudo make install

# sudo ldconfig
# sudo make comments-install
