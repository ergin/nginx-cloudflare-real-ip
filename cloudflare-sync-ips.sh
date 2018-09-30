#!/bin/bash
echo "#Cloudflare" > /etc/nginx/cloudflare;
echo "" >> /etc/nginx/cloudflare;

echo "# - IPv4" >> /etc/nginx/cloudflare;
for i in `curl https://www.cloudflare.com/ips-v4`; do
        echo "set_real_ip_from $i;" >> /etc/nginx/cloudflare;
done

echo "" >> /etc/nginx/cloudflare;
echo "# - IPv6" >> /etc/nginx/cloudflare;
for i in `curl https://www.cloudflare.com/ips-v6`; do
        echo "set_real_ip_from $i;" >> /etc/nginx/cloudflare;
done

echo "" >> /etc/nginx/cloudflare;
echo "real_ip_header CF-Connecting-IP;" >> /etc/nginx/cloudflare;

#test configuration and reload nginx
nginx -t && systemctl reload nginx
