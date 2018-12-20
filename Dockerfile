FROM golang:1.11-alpine as builder

# Install tooling
RUN apk add -y git make \
    \
    && mkdir -p /go/src/github.com/bitnami-labs

ARG SEALED_SECRETS_VERSION=v0.7.0

RUN cd /go/src/github.com/bitnami-labs \
    && git clone https://github.com/bitnami-labs/sealed-secrets.git sealed-secrets \
    && cd sealed-secrets \
    && git checkout ${SEALED_SECRETS_VERSION}

WORKDIR /go/src/github.com/bitnami-labs/sealed-secrets/

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o controller ./cmd/controller


FROM scratch
COPY --from=builder /go/src/github.com/bitnami-labs/sealed-secrets/controller /usr/local/bin/sealed-secrets-controller
ENTRYPOINT [ "/usr/local/bin/sealed-secrets-controller" ]
