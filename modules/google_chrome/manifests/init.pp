# == Class: google_chrome
#
# Install chromium <http://chromium.org/> from Ubuntu repos.
#
class google_chrome {
  include govuk_ppa

  package { 'chromium-browser':
    ensure => present,
  }
}
