if [[ $? = 0 ]]; then
  NAGIOS_CODE=0
  NAGIOS_MESSAGE=\"OK\"
else
  NAGIOS_CODE=2
  NAGIOS_MESSAGE=\"CRITICAL\"
fi

printf \"${::fqdn}\t${title}\t\${NAGIOS_CODE}\t\${NAGIOS_MESSAGE}\\n\" | /usr/sbin/send_nsca -H alert.cluster >/dev/null
