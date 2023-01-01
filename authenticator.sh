#!/bin/bash
PROG_DIR="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
source "${PROG_DIR}/.env" || exit 1

echo "ADD TXT: $certbot_VALIDATION"

# Create TXT record
CREATE_DOMAIN="_acme-challenge" # For Arvan cloud
# CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
RECORD_ID=$(curl -s -X POST "https://napi.arvancloud.ir/cdn/4.0/domains/$CERTBOT_DOMAIN/dns-records" \
     -H     "Authorization: $API_KEY" \
     -H     "Content-Type: application/json" \
     --data '{"type":"TXT","name":"'"$CREATE_DOMAIN"'","value":{"text": "'"$certbot_VALIDATION"'"},"ttl":120}' \
             | python -c "import sys,json;print(json.load(sys.stdin)['data']['id'])")
             
# Save info for cleanup
if [ ! -d /tmp/certbot_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/certbot_$CERTBOT_DOMAIN
fi
echo $RECORD_ID >> /tmp/certbot_$CERTBOT_DOMAIN/RECORD_IDS

# Sleep to make sure the change has time to propagate over to DNS
sleep ${delay:-45}
