#!/bin/bash

##You MUST have a public IP address.
##You MUST have a domain with a DNS server
##You MUST have already created a 'A' record for the takserver, and pointed it at your public IP address

##If you don't have all of this, do NOT run this script. It will fail.


certNameVar="PUT_DOMAIN_HERE"

## Conduct a certificate renewal dry run to verify permissions and path
sudo certbot renew --force-renewal



echo "complete - wait a minute before checking"
