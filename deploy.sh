#!/bin/bash
PROG_DIR="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
source "${PROG_DIR}/.env" || exit 1

if [ -x "$(command -v haproxy)" ]; then
    echo "Genrate HAProxy fullchain for $CERTBOT_DOMAIN"
    cat /etc/letsencrypt/live/$CERTBOT_DOMAIN/fullchain.pem /etc/letsencrypt/live/$CERTBOT_DOMAIN/privkey.pem > /etc/haproxy/ssl/$CERTBOT_DOMAIN.pem

    echo "Reload HAProxy"
    systemctl reload haproxy
fi
if [ -x "$(command -v nginx)" ]; then
    if nginx_out=$(nginx -t 2>&1); then
        echo "Reloading Nginx..."
        systemctl reload nginx
        echo "Nginx reloaded!"
    else
        echo "Nginx configuration validation failed!"
        echo "Detail:"
        echo "$nginx_out"
    fi
fi



