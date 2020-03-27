# == Class: grafana::repo
#
# === Parameters:
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#
class grafana::repo (
  $apt_mirror_hostname,
) {
  # TODO: upgrade Grafana in AWS Prod and Carrenza (all envs).
  if $::aws_environment in ['integration', 'staging'] {
    apt::source { 'grafana-stable':
      location     => "http://${apt_mirror_hostname}/grafana-stable",
      release      => 'stable',
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',  # GOV.UK Production APT
    }
  } else {
    apt::source { 'grafana':
      location     => "http://${apt_mirror_hostname}/grafana",
      release      => 'jessie',
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    }
  }
}
