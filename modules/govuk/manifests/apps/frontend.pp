class govuk::apps::frontend( $port = 3005 ) {
  govuk::app { 'frontend':
    app_type      => 'rack',
    port          => $port,
    vhost         => 'www',
    vhost_aliases => ['frontend'],
  }

  # nginx::config::vhost::static needs this link to be here
  # it assumes a file structure of /data/vhost/{app}.{platform}.alphagov.co.uk/shared/public/{app}
  # but for frontend, it's /data/vhost/www.{platform}.alphagov.co.uk/shared/public/frontend
  file { "/data/vhost/frontend.${::govuk_platform}.alphagov.co.uk":
    ensure => link,
    target => "/data/vhost/www.${::govuk_platform}.alphagov.co.uk",
    owner  => 'deploy',
    group  => 'deploy',
  }
}
