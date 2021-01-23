#!/bin/bash
#########################################################################
#renew-certs.sh
#This Script uses certbot/certbot docker container to renew the letsencrypt
#SSL certificates.
#by A. Laub
#andreas[-at-]laub-home.de
#
#License:
#This program is free software: you can redistribute it and/or modify it
#under the terms of the GNU General Public License as published by the
#Free Software Foundation, either version 3 of the License, or (at your option)
#any later version.
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#or FITNESS FOR A PARTICULAR PURPOSE.
#########################################################################
#Set the language
export LANG="en_US.UTF-8"
#Load the Pathes
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# first stoping the nginxproxy
docker-compose stop

# renew the certificates
docker run -it --rm \
-v $(pwd)/data/letsencrypt/conf:/etc/letsencrypt \
-v $(pwd)/data/letsencrypt/lib:/var/lib/letsencrypt \
-v $(pwd)/data/letsencrypt/webroot:/data/letsencrypt \
-v $(pwd)/data/letsencrypt/logs:/var/log/letsencrypt \
certbot/certbot renew 

# at least start the nginxproxy
docker-compose start

