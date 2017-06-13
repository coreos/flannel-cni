*Example for deploying flannel daemonset:*

flannel-configmap:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-flannel-cfg
  namespace: kube-system
  labels:
    tier: node
    k8s-app: flannel
data:
  cni-conf.json: |
    {
      "name": "cbr0",
      "type": "flannel",
      "delegate": {
        "isDefaultGateway": true
      }
    }
  net-conf.json: |
    {
      "Network": "{{ .PodCIDR }}",
      "Backend": {
        "Type": "vxlan"
      }
    }
```

flannel-daemonset:

```yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: kube-flannel
  namespace: kube-system
  labels:
    tier: node
    k8s-app: flannel
spec:
  template:
    metadata:
      labels:
        tier: node
        k8s-app: flannel
    spec:
      containers:
      - name: kube-flannel
        image: quay.io/coreos/flannel:v0.7.1-amd64
        command: [ "/opt/bin/flanneld", "--ip-masq", "--kube-subnet-mgr", "--iface=$(POD_IP)"]
        securityContext:
          privileged: true
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        volumeMounts:
        - name: run
          mountPath: /run
        - name: cni
          mountPath: /etc/cni/net.d
        - name: flannel-cfg
          mountPath: /etc/kube-flannel/
      - name: install-cni
        image: quay.io/coreos/flannel-cni:0.1
        command: ["/install-cni.sh"]
        env:
        # The CNI network config to install on each node.
        - name: CNI_NETWORK_CONFIG
            valueFrom:
            configMapKeyRef:
                name: kube-flannel-cfg
                key: cni-conf.json
        volumeMounts:
        - name: cni
          mountPath: /etc/cni/net.d
        - name: host-cni-bin
          mountPath: /host/opt/cni/bin/
      hostNetwork: true
      tolerations:
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      volumes:
        - name: run
          hostPath:
            path: /run
        - name: cni
          hostPath:
            path: /etc/kubernetes/cni/net.d
        - name: flannel-cfg
          configMap:
            name: kube-flannel-cfg
        - name: host-cni-bin
          hostPath:
            path: /opt/cni/bin
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate
```