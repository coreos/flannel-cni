FROM busybox

ADD dist/flannel /opt/cni/bin/flannel
ADD dist/loopback /opt/cni/bin/loopback
ADD dist/bridge /opt/cni/bin/bridge
ADD dist/cnitool /opt/cni/bin/cnitool
ADD dist/dhcp /opt/cni/bin/dhcp
ADD dist/ipvlan /opt/cni/bin/ipvlan
ADD dist/macvlan /opt/cni/bin/macvlan
ADD dist/noop /opt/cni/bin/noop
ADD dist/portmap /opt/cni/bin/portmap
ADD dist/ptp /opt/cni/bin/ptp
ADD dist/tuning /opt/cni/bin/tuning
ADD dist/host-local /opt/cni/bin/host-local
ADD dist/vlan /opt/cni/bin/vlan

ADD install-cni.sh /install-cni.sh
ADD flannel.conflist.default /flannel.conflist.default
