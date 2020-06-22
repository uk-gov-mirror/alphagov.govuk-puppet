# == Class: govuk::apps::email_alert_api:checks
#
# Various Icinga checks for Email Alert API.
#
class govuk::apps::email_alert_api::checks(
  $ensure = present,
) {

  sidekiq_queue_check {
    [
      'email_generation_immediate',
      'process_and_generate_emails',
      'default',
      'email_generation_digest',
      'cleanup',
    ]:
      size_warning     => '75000',
      size_critical    => '100000',
      latency_warning  => '300', # 5 minutes
      latency_critical => '600'; # 10 minutes

    'delivery_immediate':
      size_warning     => '75000',
      size_critical    => '100000',
      latency_warning  => '1200', # 20 minutes
      latency_critical => '1800'; # 30 minutes

    'delivery_immediate_high':
      size_warning     => '75000',
      size_critical    => '100000',
      latency_warning  => '300', # 5 minutes
      latency_critical => '600'; # 10 minutes

    'delivery_digest':
      size_warning     => '75000',
      size_critical    => '100000',
      latency_warning  => '3600', # 60 minutes
      latency_critical => '5400'; # 90 minutes
  }

  sidekiq_retry_size_check { 'retry_set_size':
    retry_size_warning  => '40000',
    retry_size_critical => '50000',
  }

  delivery_attempt_status_check { 'internal_failure':
    ensure => $ensure,
  }

  delivery_attempt_status_check { 'technical_failure':
    ensure => $ensure,
  }

  @@icinga::check::graphite { 'email-alert-api-notify-email-send-request-success':
    host_name => $::fqdn,
    target    => 'summarize(groupByNode(consolidateBy(stats_counts.govuk.app.email-alert-api.*.notify.email_send_request.*, "sum"), 1, "sum"), "1d", "sum", false)',
    args      => '--ignore-missing',
    warning   => '20000000', # 25,000,000 * 0.8
    critical  => '22500000', # 25,000,000 * 0.9
    from      => '3hours',
    desc      => 'email-alert-api - high number of email send requests',
  }

  @@icinga::check::graphite { 'email-alert-api-delivery-attempt-status-update':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(divideSeries(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.delivery_attempt.pending_status_total)), keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.delivery_attempt.total))),0)',
    warning   => '0.166',
    critical  => '0.25',
    from      => '1hour',
    desc      => 'email-alert-api - high number of delivery attempts have not received status updates',
    notes_url => monitoring_docs_url(email-alert-api-delivery-attempts-status-updates),
  }

  # We are only interested in the `warning` state but `critical` is also required
  # for valid Icinga check configuration. Setting it to a high value that won't be
  # reached allows us to get round this issue
  @@icinga::check::graphite { 'email-alert-api-warning-subscription-contents':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.subscription_contents.warning_total)))',
    warning   => '0',
    critical  => '100000000',
    from      => '15minutes',
    desc      => 'email-alert-api - unprocessed subscription contents - warning',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-subscription-contents),
  }

  @@icinga::check::graphite { 'email-alert-api-warning-content-changes':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.content_changes.warning_total)))',
    warning   => '0',
    critical  => '100000000',
    from      => '15minutes',
    desc      => 'email-alert-api - unprocessed content changes - warning',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-content-changes),
    }

  @@icinga::check::graphite { 'email-alert-api-warning-digest-runs':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.digest_runs.warning_total)))',
    warning   => '0',
    critical  => '100000000',
    from      => '1hour',
    desc      => 'email-alert-api - incomplete digest runs - warning',
    notes_url => monitoring_docs_url(email-alert-api-incomplete-digest-runs),
  }

  @@icinga::check::graphite { 'email-alert-api-warning-messages':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.messages.warning_total)))',
    warning   => '0',
    critical  => '100000000',
    from      => '1hour',
    desc      => 'email-alert-api - unprocessed messages - warning',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-messages),
  }

  # We are only interested in the `critical` state but `warning` is also required
  # for valid Icinga check configuration. Both states are set to 0 but `critical`
  # takes precedence and allows us to get round this issue
  @@icinga::check::graphite { 'email-alert-api-critical-subscription-contents':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.subscription_contents.critical_total)))',
    warning   => '0',
    critical  => '0',
    from      => '15minutes',
    desc      => 'email-alert-api - unprocessed subscription contents - critical',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-subscription-contents),
  }

  @@icinga::check::graphite { 'email-alert-api-critical-content-changes':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.content_changes.critical_total)))',
    warning   => '0',
    critical  => '0',
    from      => '15minutes',
    desc      => 'email-alert-api - unprocessed content changes - critical',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-content-changes),
  }

  @@icinga::check::graphite { 'email-alert-api-critical-digest-runs':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.digest_runs.critical_total)))',
    warning   => '0',
    critical  => '0',
    from      => '1hour',
    desc      => 'email-alert-api - incomplete digest runs - critical',
    notes_url => monitoring_docs_url(email-alert-api-incomplete-digest-runs),
  }

  @@icinga::check::graphite { 'email-alert-api-critical-messages':
    ensure    => $ensure,
    host_name => $::fqdn,
    target    => 'transformNull(keepLastValue(averageSeries(stats.gauges.govuk.app.email-alert-api.*.messages.critical_total)))',
    warning   => '0',
    critical  => '0',
    from      => '1hour',
    desc      => 'email-alert-api - unprocessed messages - critical',
    notes_url => monitoring_docs_url(email-alert-api-unprocessed-messages),
  }
}
