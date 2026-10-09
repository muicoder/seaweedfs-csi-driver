#!/bin/sh

set -e

cd "$(dirname "$(readlink -f "$0")")"
if grep -n SEAWEEDFS_FILER: deploy/helm/seaweedfs-csi-driver/values.yaml; then
  echo "Please modify the above SEAWEEDFS_FILER to the address(filer), eg: 1.2.4.8:8888"
fi
sed -E "s~registry.k8s.io/sig-storage~muicoder~g;$(wget -qO- https://github.com/longhorn/longhorn/raw/master/deploy/longhorn-images.txt | grep :v | while read -r i; do echo "s~${i%:*}.+~$i~"; done | xargs | sed 's~ ~;~g')" deploy/helm/seaweedfs-csi-driver/values.yaml >.sed
mv .sed deploy/helm/seaweedfs-csi-driver/values.yaml
helm --namespace default template seaweedfs deploy/helm/seaweedfs-csi-driver | sed '/^[ ]*$/d;/replicas:/d' >deploy/seaweedfs-csi-driver.yaml
