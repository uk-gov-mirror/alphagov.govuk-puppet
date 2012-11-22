define govuk::app::config (
  $app_type,
  $domain,
  $port,
  $vhost_full,
  $vhost_aliases = [],
  $vhost_protected = undef,
  $vhost_ssl_only = false,
  $nginx_extra_config = '',
  $nginx_extra_app_config = '',
  $platform = $::govuk_platform,
  $health_check_path = 'NOTSET',
  $enable_nginx_vhost = true
) {

  if $health_check_path == 'NOTSET' {
    $health_check_port = 'NOTSET'
    $ssl_health_check_port = 'NOTSET'
  } else {
    $health_check_port = $port + 6500
    $ssl_health_check_port = $port + 6400
    @ufw::allow {
      "allow-loadbalancer-health-check-${title}-http-from-all":
        port => $health_check_port;
      "allow-loadbalancer-health-check-${title}-https-from-all":
        port => $ssl_health_check_port;
    }
  }

  # Ensure config dir exists
  file { "/etc/govuk/${title}":
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true,
    notify  => Govuk::App::Service[$title],
  }

  # Ensure env dir exists
  file { "/etc/govuk/${title}/env.d":
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true,
    notify  => Govuk::App::Service[$title],
  }

  # This sets the default app for this resource type in the current scope
  Govuk::App::Envvar {
    app => $title
  }

  govuk::app::envvar {
    "${title}-GOVUK_USER":
      varname => "GOVUK_USER",
      value   => "deploy";
    "${title}-GOVUK_GROUP":
      varname => "GOVUK_GROUP",
      value   => "deploy";
    "${title}-GOVUK_APP_TYPE":
      varname => "GOVUK_APP_TYPE",
      value   => $app_type;
    "${title}-PORT":
      varname => "PORT",
      value   => $port;
    "${title}-GOVUK_APP_NAME":
      varname => "GOVUK_APP_NAME",
      value   => $title;
    "${title}-GOVUK_APP_ROOT":
      varname => "GOVUK_APP_ROOT",
      value   => "/var/apps/${title}";
    "${title}-GOVUK_APP_RUN":
      varname => "GOVUK_APP_RUN",
      value   => "/var/run/${title}";
    "${title}-GOVUK_APP_LOGROOT":
      varname => "GOVUK_APP_LOGROOT",
      value   => "/var/log/${title}";
    "${title}-GOVUK_STATSD_PREFIX":
      varname => "GOVUK_STATSD_PREFIX",
      value   => "govuk.app.${title}.${::hostname}";
  }

  # Install service
  file { "/etc/init/${title}.conf":
    content => template('govuk/app_upstart.conf.erb'),
    notify  => Service[$title],
  }

  $vhost_aliases_real = regsubst($vhost_aliases, '$', ".${domain}")

  # By default, apps are unprotected in Skyscape, unless they
  # explicitly declare that they want to be. Otherwise, they are protected by
  # default.
  if $vhost_protected == undef {
    $vhost_protected_real = $::govuk_provider ? {
      'sky'   => false,
      default => true,
    }
  } else {
    $vhost_protected_real = $vhost_protected
  }

  if $enable_nginx_vhost {
    # Expose this application from nginx
    nginx::config::vhost::proxy { $vhost_full:
      to                    => ["localhost:${port}"],
      aliases               => $vhost_aliases_real,
      protected             => $vhost_protected_real,
      ssl_only              => $vhost_ssl_only,
      extra_config          => $nginx_extra_config,
      extra_app_config      => $nginx_extra_app_config,
      platform              => $platform,
      health_check_path     => $health_check_path,
      health_check_port     => $health_check_port,
      ssl_health_check_port => $ssl_health_check_port,
    }
  }

  # Set up monitoring
  @ganglia::pymod_alias { "app-${title}-procstat":
    target => "procstat",
  }

  @ganglia::pyconf { "app-${title}":
    content => template('govuk/etc/ganglia/conf.d/procstat.pyconf.erb'),
    require => File["/usr/lib/ganglia/python_modules/app-${title}-procstat.py"]
  }

  @logstash::collector { "app-${title}":
    content => template('govuk/app_logstash.conf.erb'),
  }

  @logrotate::conf { "govuk-${title}":
    matches => "/var/log/${title}/*.log",
  }

  @logrotate::conf { "govuk-${title}-rack":
    matches => "/data/vhost/${vhost_full}/shared/log/*.log",
  }

  @@nagios::check { "check_${title}_app_cpu_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_cpu!50!100",
    service_description => "high CPU usage for ${title} app",
    host_name           => $::fqdn,
  }
  @@nagios::check { "check_${title}_app_mem_usage${::hostname}":
    check_command       => "check_ganglia_metric!procstat_${title}_mem!2000000000!3000000000",
    service_description => "high memory for ${title} app",
    host_name           => $::fqdn,
  }
  if $health_check_path != 'NOTSET' {
    @@nagios::check { "check_app_${title}_up_on_${::hostname}":
      check_command       => "check_nrpe!check_app_up!${port} ${health_check_path}",
      service_description => "${title} app running",
      host_name           => $::fqdn,
    }
  }
}
