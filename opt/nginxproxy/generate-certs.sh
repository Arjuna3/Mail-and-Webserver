#!/bin/bash
#########################################################################
#generate-certs.sh
#This Script uses certbot/certbot docker container to generate letsencrypt
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

# set the variables

# Please at first define all domains in domains.txt
# comma seperated: www.example.de,test.example.de
# first domain will be the name of cert
# one certificate per line would be generated:
# www.example.de,test.example.de
# www.example.com,test.example.com
# www.example.tld,test.example.tld

# E-Mail adress for register at letsencrypt
MAILADRESS=mailadresse@example.tld
# for testing propose you can enable staging, just uncomment the line for staging
#STAGING=--staging


#########################################################################
# start the things

# first stoping the nginxproxy
docker-compose stop

# now generating certs with domainnames out of domains.txt
for domain in $(cat domains.txt); do
        docker run -it --rm \
        -p 80:80 \
        -v $(pwd)/data/letsencrypt/conf:/etc/letsencrypt \
        -v $(pwd)/data/letsencrypt/lib:/var/lib/letsencrypt \
        -v $(pwd)/data/letsencrypt/webroot:/data/letsencrypt \
        -v $(pwd)/data/letsencrypt/logs:/var/log/letsencrypt \
        certbot/certbot \
        certonly --standalone ${STAGING} \
        --expand \
        --webroot-path=/data/letsencrypt \
        --rsa-key-size=4096 \
        -d ${domain} \
        --no-eff-email --agree-tos \
        -m ${MAILADRESS}
done

# Change for renew to webroot
sed -i 's/'"authenticator = standalone"'/'"authenticator = webroot"'/g' $(pwd)/data/letsencrypt/conf/renewal/* 

# now starting nginxproxy
docker-compose up -d

