FROM alpine:latest

RUN apk add --update bash jq && rm -rf /var/cache/apk/*

ENV bosh_cli_version=2.0.30
ADD https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${bosh_cli_version}-linux-amd64 /usr/local/bin/bosh
RUN chmod +x /usr/local/bin/bosh

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
RUN mkdir /opt/resource/logs/