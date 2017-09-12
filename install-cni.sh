#!/bin/sh

set -e -x;

if [ -w "/host/opt/cni/bin/" ]; then
    cp /opt/cni/bin/* /host/opt/cni/bin/;
    echo "Wrote CNI binaries to /host/opt/cni/bin/";
fi;

TMP_CONF='/flannel.conflist.default'
# If specified, overwrite the network configuration file.
if [ "${CNI_NETWORK_CONFIG:-}" != "" ]; then
cat >$TMP_CONF <<EOF
${CNI_NETWORK_CONFIG:-}
EOF
fi

CNI_CONF_NAME="${CNI_CONF_NAME:-10-flannel.conflist}"
CNI_OLD_NAME="${CNI_OLD_NAME:-10-flannel.conf}"
if [ "${CNI_CONF_NAME}" != "${CNI_OLD_NAME}" ]; then
    rm -f "/host/etc/cni/net.d/${CNI_OLD_NAME}"
fi
mv $TMP_CONF /host/etc/cni/net.d/${CNI_CONF_NAME}
echo "Wrote CNI config: $(cat /host/etc/cni/net.d/${CNI_CONF_NAME})"

while :; do sleep 3600; done;
