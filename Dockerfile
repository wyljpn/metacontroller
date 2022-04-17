#FROM golang:1.10 AS build
FROM golang:1.17 AS build
#FROM klstg-docker.slb-wartifactory-v.stg.rmn.local/rakuten/rflow/rflow-go:1.17 AS build

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

COPY . /go/src/metacontroller.app/
WORKDIR /go/src/metacontroller.app/
RUN go mod init
RUN dep ensure 
RUN go install -mod=mod

#FROM debian:stretch-slim
FROM klstg-docker.slb-wartifactory-v.stg.rmn.local/rakuten/rflow/rflow-ubuntu:20.04
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build /go/bin/metacontroller.app /usr/bin/metacontroller
CMD ["/usr/bin/metacontroller"]
