# == Class: monitoring
#
# Sets up monitoring.
#
# === Parameters:
#
# [*ci_environment*]
#   Disables lots of default alerts if this is the CI environment.
#
class monitoring (
  $ci_environment = false,
) {

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include ::govuk_jenkins::packages::govuk_python
  include icinga
  include nsca::server

  include govuk_htpasswd
  include monitoring::contacts
  include monitoring::event_handlers

  include monitoring::gcloud

  unless $ci_environment {
    # Monitoring server only.
    include monitoring::checks
    include monitoring::edge
    include monitoring::pagerduty_drill
    include monitoring::uptime_collector
  }
}
