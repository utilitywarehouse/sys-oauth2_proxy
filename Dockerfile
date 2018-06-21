FROM golang:1.10 AS builder
ENV VERSION_TAG v2.2
WORKDIR /go/src/github.com/bitly/oauth2_proxy
RUN git clone --branch ${VERSION_TAG} https://github.com/bitly/oauth2_proxy . \
    && go get -d -v \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/bitly/oauth2_proxy/oauth2_proxy .

ENTRYPOINT ["/root/oauth2_proxy"]
