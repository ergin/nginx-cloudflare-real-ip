# Get Real Visitor IP Address (Restoring Visitor IPs) with Nginx and CloudFlare
This project aims to modify your nginx configuration to let you get the real ip address of your visitors for your web applications that behind of Cloudflare's reverse proxy network. Bash script can be scheduled to create an automated up-to-date Cloudflare ip list file.

To provide the client (visitor) IP address for every request to the origin, Cloudflare adds the "CF-Connecting-IP" header. We will catch the header and get the real ip address of the visitor.

## Nginx Configuration
With a small configuration modification we can integrate replacing the real ip address of the visitor instead of getting CloudFlare's load balancers' ip addresses.

Open "/etc/nginx/nginx.conf" file with your favorite text editor and just add the following lines to your nginx.conf inside http{....} block.

```nginx
include /etc/nginx/cloudflare;
```

The bash script may run manually or can be scheduled to refresh the ip list of CloudFlare automatically.
```sh
#!/bin/bash

CLOUDFLARE_FILE_PATH=/etc/nginx/cloudflare

echo "#Cloudflare" > $CLOUDFLARE_FILE_PATH;
echo "" >> $CLOUDFLARE_FILE_PATH;

echo "# - IPv4" >> $CLOUDFLARE_FILE_PATH;
for i in `curl -s -L https://www.cloudflare.com/ips-v4`; do
    echo "set_real_ip_from $i;" >> $CLOUDFLARE_FILE_PATH;
done

echo "" >> $CLOUDFLARE_FILE_PATH;
echo "# - IPv6" >> $CLOUDFLARE_FILE_PATH;
for i in `curl -s -L https://www.cloudflare.com/ips-v6`; do
    echo "set_real_ip_from $i;" >> $CLOUDFLARE_FILE_PATH;
done

echo "" >> $CLOUDFLARE_FILE_PATH;
echo "real_ip_header CF-Connecting-IP;" >> $CLOUDFLARE_FILE_PATH;

# Test configuration and reload nginx
nginx -t && nginx -s reload
```

## Output
Your "/etc/nginx/cloudflare" file may look like as below;

```nginx
#Cloudflare ip addresses

# - IPv4
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 104.16.0.0/13;
set_real_ip_from 104.24.0.0/14;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 131.0.72.0/22;

# - IPv6
set_real_ip_from 2400:cb00::/32;
set_real_ip_from 2606:4700::/32;
set_real_ip_from 2803:f800::/32;
set_real_ip_from 2405:b500::/32;
set_real_ip_from 2405:8100::/32;
set_real_ip_from 2a06:98c0::/29;
set_real_ip_from 2c0f:f248::/32;

real_ip_header CF-Connecting-IP;
```

## Crontab
Change the location of "/opt/scripts/cloudflare-ip-whitelist-sync.sh" anywhere you want. 
CloudFlare ip addresses are automatically refreshed every day, and nginx will be realoded when synchronization is completed.
```sh
# Auto sync ip addresses of Cloudflare and reload nginx
30 2 * * * /opt/scripts/cloudflare-ip-whitelist-sync.sh >/dev/null 2>&1
```

### License

[Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0)


### DISCLAIMER
----------
Please note: all tools/ scripts in this repo are released for use "AS IS" **without any warranties of any kind**,
including, but not limited to their installation, use, or performance.  We disclaim any and all warranties, either 
express or implied, including but not limited to any warranty of noninfringement, merchantability, and/ or fitness 
for a particular purpose.  We do not warrant that the technology will meet your requirements, that the operation 
thereof will be uninterrupted or error-free, or that any errors will be corrected.

Any use of these scripts and tools is **at your own risk**.  There is no guarantee that they have been through 
thorough testing in a comparable environment and we are not responsible for any damage or data loss incurred with 
their use.

You are responsible for reviewing and testing any scripts you run *thoroughly* before use in any non-testing 
environment.

Thanks,   
[Ergin BULUT](https://www.erginbulut.com)
