FROM golang:1.22-alpine as builder
WORKDIR /go/src/github.com/seaweedfs/seaweedfs-csi-driver
COPY . .
RUN apk add --no-cache alpine-sdk && go mod tidy && CGO_ENABLED=0 go build -ldflags="-s -w -extldflags -static -X github.com/seaweedfs/seaweedfs-csi-driver/pkg/driver.driverVersion=v1.1.9 -X github.com/seaweedfs/seaweedfs-csi-driver/pkg/driver.gitCommit=$(git rev-parse --short HEAD^) -X github.com/seaweedfs/seaweedfs-csi-driver/pkg/driver.buildDate=$(git show HEAD^ --pretty=format:"%ci" | head -1 | awk '{print $1}')" -o /seaweedfs-csi-driver ./cmd/seaweedfs-csi-driver/main.go && chmod a+x /seaweedfs-csi-driver

FROM chrislusf/seaweedfs AS weed
FROM alpine:3
RUN apk add --no-cache bash libstdc++ coreutils ca-certificates curl wget tzdata fuse
COPY --from=weed /usr/bin/weed /usr/bin/
COPY --from=builder /seaweedfs-csi-driver /

ENTRYPOINT ["/seaweedfs-csi-driver"]
