# Letsencrypt wildcard with HAProxy and Arvan Cloud
**Requirements:**
- python

```bash
cp env.example .env
```
Command:
```bash
certbot certonly  --manual --preferred-challenges=dns --manual-auth-hook ./authenticator.sh --manual-cleanup-hook ./cleanup.sh  --deploy-hook ./deploy.sh  -d *.example.com -d example.com
```

Check  Certificate’s Expiration Date:
```bash
echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -dates
```

Cron:
```bash
10 0 * * * certbot renew
```