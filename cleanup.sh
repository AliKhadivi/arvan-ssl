#!/bin/bash
PROG_DIR="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
source "${PROG_DIR}/.env" || exit 1

if [ -f /tmp/certbot_$CERTBOT_DOMAIN/RECORD_IDS ]; then
        RECORD_IDS=$(cat /tmp/certbot_$CERTBOT_DOMAIN/RECORD_IDS)
        # rm -f /tmp/certbot_$CERTBOT_DOMAIN/RECORD_IDS
        rm -rf /tmp/certbot_$CERTBOT_DOMAIN/
fi

if [ "$(echo "$CERTBOT_DOMAIN" | cut -d "." -f 3)" == "" ] ; then
        DOMAIN="$CERTBOT_DOMAIN"
else
        DOMAIN="$(echo "$CERTBOT_DOMAIN" | cut -d "." -f 2).$(echo "$CERTBOT_DOMAIN" | cut -d "." -f 3)"
fi

# Remove the challenge TXT record from the zone
if [ -n "${RECORD_IDS}" ]; then
    for RECORD_ID in $RECORD_IDS
    do 
        echo "Remove TXT record from $CERTBOT_DOMAIN: $RECORD_ID"
        curl -s -X DELETE "https://napi.arvancloud.ir/cdn/4.0/domains/$DOMAIN/dns-records/$RECORD_ID" \
                -H "Authorization: $API_KEY"
        echo
    done
fi
