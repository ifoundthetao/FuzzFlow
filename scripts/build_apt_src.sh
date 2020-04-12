#!/bin/bash

# installs dependenies and builds ubuntu package from source 
# set CC / CXX environment variables as needed 

USAGE="$0 <apt package> ..."

if [ $# -lt 1 ]; then
    echo "$USAGE"
    exit 1
fi

CPU_COUNT=1
#CPU_COUNT=$(getconf _NPROCESSORS_ONLN 2>/dev/null || getconf NPROCESSORS_ONLN 2>/dev/null || echo 1)

while (($#)); do
    FUZZ_TARGET=$1
    sudo apt-get -y install $1 && \
    mkdir -p /tmp/$FUZZ_TARGET && \
    cd /tmp/$FUZZ_TARGET && \
    sudo apt-get build-dep -y $FUZZ_TARGET && \
    apt-get source -y $FUZZ_TARGET && \
    cd * && \
    dpkg-buildpackage -uc -us -j$(( $CPU_COUNT -1 ))
    shift
done
