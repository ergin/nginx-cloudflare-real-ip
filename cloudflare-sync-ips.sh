#!/bin/bash

cf_ips="$(curl -fsLm2 --retry 1 https://api.cloudflare.com/client/v4/ips)"
CLOUDFLARE_FILE_PATH=${1:-/etc/nginx/cloudflare}

echo "# Cloudflare IP Ranges" > $CLOUDFLARE_FILE_PATH
echo "" >> $CLOUDFLARE_FILE_PATH
echo "# - IPv4" >> $CLOUDFLARE_FILE_PATH
for ipv4 in $(echo "$cf_ips" | jq -r '.result.ipv4_cidrs[]//""' | sort); do
	echo "set_real_ip_from $ipv4;" >> $CLOUDFLARE_FILE_PATH
done
echo "" >> $CLOUDFLARE_FILE_PATH
echo "# - IPv6" >> $CLOUDFLARE_FILE_PATH
for ipv6 in $(echo "$cf_ips" | jq -r '.result.ipv6_cidrs[]//""' | sort); do
    echo "set_real_ip_from $ipv6;" >> $CLOUDFLARE_FILE_PATH
 done
 echo "" >> $CLOUDFLARE_FILE_PATH
 echo "real_ip_header CF-Connecting-IP;" >> $CLOUDFLARE_FILE_PATH

#test configuration and reload nginx
nginx -t && systemctl reload nginx
