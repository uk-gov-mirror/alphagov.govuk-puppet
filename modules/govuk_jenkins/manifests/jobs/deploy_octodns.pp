# == Class: govuk_jenkins::jobs::deploy_octodns
#
# Create the Jenkins job to deploy DNS records. through octodns
# Target platforms are:
#      AWS Route 53
#      Google Cloud DNS
#
# === Parameters
#
# [*gce_project_id*]
#   The name of the Google Compute Engine project that contains the resources you want to interact with.
#
# [*gce_credential_id*]
#   Jenkins credential ID that stores the Gcloud account.
#
# [*zones*]
#   An array of zones to deploy.
#
class govuk_jenkins::jobs::deploy_octodns (
  $gce_project_id = undef,
  $gce_credential_id = undef,
  $zones = [],
) {

  validate_array($zones)

  file { '/etc/jenkins_jobs/jobs/deploy_octodns.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_octodns.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }

}
