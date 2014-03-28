# encoding: UTF-8

name              'rackspace_rsyslog'
maintainer        'Rackspace, US Inc.'
maintainer_email  'rackspace-cookbooks@rackspace.com'
license           'Apache 2.0'
description       'Installs and configures rsyslog'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '2.0.0'

recipe            'rsyslog', 'Installs rsyslog'
recipe            'rsyslog::client', 'Sets up a client to log to a remote rsyslog server'
recipe            'rsyslog::server', 'Sets up an rsyslog server'

supports          'ubuntu', '>= 12.04'
supports          'debian', '>= 7.2'
supports          'redhat', '>= 6.3'
supports	      'centos', '>= 6.3'
