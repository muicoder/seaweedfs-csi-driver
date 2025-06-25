FROM chrislusf/seaweedfs-csi-driver AS builder
FROM chrislusf/seaweedfs AS weed
FROM alpine:3.16
RUN apk add --no-cache bash ca-certificates curl wget tzdata fuse
COPY --chown=0:0 --chmod=0755 --from=builder /seaweedfs-csi-driver /
COPY --chown=0:0 --chmod=0755 --from=weed /usr/bin/weed /usr/bin/

ENTRYPOINT ["/seaweedfs-csi-driver"]
