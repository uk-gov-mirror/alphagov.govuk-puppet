# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_jenkins::ssh_key {
  $private_key = '/home/jenkins/.ssh/id_rsa'
  $public_key = '/home/jenkins/.ssh/id_rsa.pub'

  file { $public_key:
    checksum => md5,
    require  => [ User['jenkins'], File['/home/jenkins/.ssh'] ],
  }

  file { '/home/jenkins/.ssh':
    ensure => directory,
    mode   => '0600',
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  exec { 'Creating key pair for jenkins':
    command => "ssh-keygen -t rsa -C 'Provided by Puppet for jenkins' -N '' -f ${private_key}",
    creates => $private_key,
    require => [
      User['jenkins'],
      File['/home/jenkins/.ssh']
    ],
    user    => 'jenkins',
  }

  package { 'keychain':
    ensure => 'installed'
  }

  file { '/home/jenkins/.bashrc':
    source  => 'puppet:///modules/govuk_jenkins/dot-bashrc',
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
    require => Package['keychain'],
  }
}
