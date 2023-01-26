# Letsencrypt wildcard with Certbot and ArvanCloud dns provider
## Install and configuration
### Requirements:
- Python
- Certbot

### Install Certbot:
```bash
sudo snap install certbot --classic
```

### Install python:
```bash
sudo apt install python3
```
### Configure
Copy `.env`
```bash
cp env.example .env
```
**Notice:** You need to get the api key from your ArvanCloud panel and put it in the `.env` file
## Usage

**Command:**
```bash
certbot certonly  --manual --preferred-challenges=dns --manual-auth-hook ./authenticator.sh --manual-cleanup-hook ./cleanup.sh  --deploy-hook ./deploy.sh  -d *.example.com -d example.com
```

**Check  Certificate’s Expiration Date:**
```bash
echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -dates
```

**Cron:**
```bash
10 0 * * * certbot renew
```
