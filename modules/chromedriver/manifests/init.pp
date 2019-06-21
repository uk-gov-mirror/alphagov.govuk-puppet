# == Class: chromedriver
#
# Install chromedriver <http://chromedriver.chromium.org/> from Ubuntu repos.
#
class chromedriver {
  include govuk_ppa

  package { 'chromium-chromedriver':
    ensure => present,
  }
}
