FROM chrislusf/seaweedfs-csi-driver AS builder
FROM chrislusf/seaweedfs-mount AS mount
FROM chrislusf/seaweedfs AS weed
FROM scratch AS final
COPY --chown=0:0 --chmod=0555 --from=builder /seaweedfs-csi-driver /
COPY --chown=0:0 --chmod=0555 --from=mount /seaweedfs-mount /
COPY --chown=0:0 --chmod=0555 --from=weed /usr/bin/weed /usr/bin/
FROM alpine:latest
COPY --from=final / /
RUN apk add --no-cache bash ca-certificates curl wget tzdata fuse
ENTRYPOINT ["/seaweedfs-csi-driver"]
