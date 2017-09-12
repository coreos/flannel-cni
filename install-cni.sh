#!/bin/sh

set -e -x;

if [ -w "/host/opt/cni/bin/" ]; then
    cp /opt/cni/bin/* /host/opt/cni/bin/;
    echo "Wrote CNI binaries to /host/opt/cni/bin/";
fi;

TMP_CONF='/flannel.conf.default'
# If specified, overwrite the network configuration file.
if [ "${CNI_NETWORK_CONFIG:-}" != "" ]; then
cat >$TMP_CONF <<EOF
${CNI_NETWORK_CONFIG:-}
EOF
fi

FILENAME=${CNI_CONF_NAME:-10-flannel.conf}
mv $TMP_CONF /host/etc/cni/net.d/${FILENAME}
echo "Wrote CNI config: $(cat /host/etc/cni/net.d/${FILENAME})"

if [ "${CNI_INSTALL_TYPE:-init}" == "container" ]; then
    while :; do sleep 3600; done;
fi
