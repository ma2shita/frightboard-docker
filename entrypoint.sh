#!/bin/sh

PROCFS=${1:-"/wproc"}

test -d ${PROCFS}
if [ $? -eq 0 ]; then
	echo -n "Tune of linux kernel params for "
	case "$INSTANCE_TYPE" in
	*)
		echo "standard"
		echo 65535        > ${PROCFS}/sys/net/core/somaxconn
		echo "1024 65535" > ${PROCFS}/sys/net/ipv4/ip_local_port_range
		#net.unix.max_dgram_qlen = 10
		;;
	esac
else
	cat <<-EOT
WARN: Not found ${PROCFS} on this system
May be max concurrency is 100, due to somaxconn=128
please re-run "docker run -v /proc:/wproc"
	EOT
fi

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
