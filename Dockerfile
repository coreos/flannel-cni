FROM alpine:3.6
ENV CNI_VERSION="v0.6.0"
RUN apk --update add curl tar
RUN mkdir -p /opt/cni/bin/
RUN curl -s -S -f -L --retry 5 https://github.com/containernetworking/cni/releases/download/$CNI_VERSION/cni-amd64-$CNI_VERSION.tgz | tar -xz -C /opt/cni/bin/
RUN curl -s -S -f -L --retry 5 https://github.com/containernetworking/plugins/releases/download/$CNI_VERSION/cni-plugins-amd64-$CNI_VERSION.tgz | tar -xz -C /opt/cni/bin/
RUN rm /opt/cni/bin/sample

FROM busybox
COPY --from=0 /opt/cni/bin/ /opt/cni/bin/

ADD install-cni.sh /install-cni.sh
ADD flannel.conflist.default /flannel.conflist.default
