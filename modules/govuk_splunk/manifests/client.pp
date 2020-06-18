# == Class: backup::client
#
# Configures a machine to use a user for splunk.
#

govuk_user { 'splunk':
  fullname    => 'Splunk User',
  email       => 'cyber.security@digital.cabinet-office.gov.uk',
  groups      => ['splunk','deploy'],
  purgegroups => true,
}
group { 'splunk':
  ensure => $ensure,
}
group { 'deploy':
  ensure => $ensure,
}
