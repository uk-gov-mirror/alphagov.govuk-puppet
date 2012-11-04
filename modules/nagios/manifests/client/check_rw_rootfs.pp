class nagios::client::check_rw_rootfs {
  file { '/.check_rw_rootfs':
    content => "This file was generated by puppet. It is present so the nagios user can check if the root filesystem is readonly.\n",
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0644',
  }

  @nagios::plugin { 'check_rw_rootfs':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_rw_rootfs',
  }

  @@nagios::check { "check_rw_rootfs_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_rw_rootfs',
    service_description => 'root filesystem is readonly',
    host_name           => $::fqdn,
  }
}
