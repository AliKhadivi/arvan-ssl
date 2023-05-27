#!/bin/bash
python_path=;
if [ -x "$(command -v python3)" ]; then
  python_path="$(command -v python3)";
elif [ -x "$(command -v python)" ]; then
  python_path="$(command -v python)";
elif [ -x "$(command -v python2)" ]; then
  python_path="$(command -v python2)";
fi
if ! [ -x "${python_path}" ]
then
        echo "Python is not installed!"
        exit 1
fi

PROG_DIR="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
source "${PROG_DIR}/.env" || exit 1

echo "ADD TXT: $CERTBOT_VALIDATION"
echo "https://napi.arvancloud.ir/cdn/4.0/domains/$CERTBOT_DOMAIN/dns-records"
if [ "$(echo "$CERTBOT_DOMAIN" | cut -d "." -f 3)" == "" ] ; then
        DOMAIN="$CERTBOT_DOMAIN"
        CREATE_DOMAIN="_acme-challenge"
else
        DOMAIN="$(echo "$CERTBOT_DOMAIN" | cut -d "." -f 2).$(echo "$CERTBOT_DOMAIN" | cut -d "." -f 3)"
        CREATE_DOMAIN="_acme-challenge.$(echo "$CERTBOT_DOMAIN" | cut -d "." -f 1)"
fi

# Create TXT record
#CREATE_DOMAIN="_acme-challenge" # For Arvan cloud
# CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
RESPONSE=$(curl -s -X POST "https://napi.arvancloud.ir/cdn/4.0/domains/$DOMAIN/dns-records" \
     -H     "Authorization: $API_KEY" \
     -H     "Content-Type: application/json" \
     --data '{"type":"TXT","name":"'"$CREATE_DOMAIN"'","value":{"text": "'"$CERTBOT_VALIDATION"'"},"ttl":120}')
if [ "${DEBUG:-false}" = "true" ]; then
   echo "Debug response: ${RESPONSE}"
fi
RECORD_ID=$(echo "$RESPONSE" | ${python_path} -c "import sys,json;print(json.load(sys.stdin)['data']['id'])")
             
# Save info for cleanup
if [ ! -d /tmp/certbot_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/certbot_$CERTBOT_DOMAIN
fi
echo $RECORD_ID >> /tmp/certbot_$CERTBOT_DOMAIN/RECORD_IDS

# Sleep to make sure the change has time to propagate over to DNS
echo "Wait ${delay:-45} seconds to apply."
sleep ${delay:-45}
