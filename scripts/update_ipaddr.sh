#!/bin/bash

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
FUZZFLOW_DIR=$(dirname "$SCRIPT_DIR")

# Test an IP address for validity:
# Usage:
#      valid_ip IP_ADDRESS
#      if [[ $? -eq 0 ]]; then echo good; else echo bad; fi
#   OR
#      if valid_ip IP_ADDRESS; then echo good; else echo bad; fi
#
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


if [ $# -ne 2 ]; then 
	echo "usage: $0 ip_address port"
	exit
fi

valid_ip $1
if [[ $? -ne 0 ]]; then
	echo "bad argument"
	echo
	echo "usage: $0 ip_address port"
	exit
fi

sed -i "/SERVER_ENDPOINT = / c SERVER_ENDPOINT = \'http://$1:$2/\'" $FUZZFLOW_DIR/fuzzcli/client/config.py
