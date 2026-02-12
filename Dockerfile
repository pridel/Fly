# 构建阶段
FROM golang:1.22-alpine AS builder
RUN apk add --no-cache git build-base
WORKDIR /build
RUN git clone https://github.com/klzgrad/naiveproxy.git && \
    cd naiveproxy && \
    go build -o naiveproxy ./cmd/naiveproxy

# 运行阶段
FROM alpine:3.19
RUN apk add --no-cache ca-certificates tzdata && \
    mkdir -p /app && \
    adduser -D -g '' naive
COPY --from=builder /build/naiveproxy/naiveproxy /app/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /app/naiveproxy /entrypoint.sh && \
    chown -R naive:naive /app
USER naive
EXPOSE 443
ENTRYPOINT ["/entrypoint.sh"]
