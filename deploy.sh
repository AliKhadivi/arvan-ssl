# #!/bin/bash
# PROG_DIR="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
# source "${PROG_DIR}/.env" || exit 1


# echo "Genrate HAProxy fullchain for $CERTBOT_DOMAIN"
# cat /etc/letsencrypt/live/$CERTBOT_DOMAIN/fullchain.pem /etc/letsencrypt/live/$CERTBOT_DOMAIN/privkey.pem > /etc/haproxy/ssl/$CERTBOT_DOMAIN.pem

# echo "Reload HAProxy"
# systemctl reload haproxy

# echo "Upload certificate to Arvan"
# curl -L --request POST "https://napi.arvancloud.com/cdn/4.0/domains/$CERTBOT_DOMAIN/https/certificate" \
# --header "Authorization: $API_KEY" \
# --form "f_ssl_user_key=@$(realpath /etc/letsencrypt/live/$CERTBOT_DOMAIN/privkey.pem)" \
# --form "f_ssl_user_cert=@$(realpath /etc/letsencrypt/live/$CERTBOT_DOMAIN/fullchain.pem)"



