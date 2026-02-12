#!/bin/sh
set -e

# 生成自签名证书（仅首次启动）
if [ ! -f /tmp/cert.pem ]; then
  openssl req -x509 -newkey rsa:2048 -keyout /tmp/key.pem -out /tmp/cert.pem \
    -days 365 -nodes -subj "/CN=proxy" -addext "subjectAltName=DNS:localhost"
fi

# 启动 naiveproxy（密码/域名通过 secrets 注入）
/app/naiveproxy \
  -cert /tmp/cert.pem \
  -key /tmp/key.pem \
  -password "${PASSWORD}" \
  -listen :443 \
  -loglevel error
