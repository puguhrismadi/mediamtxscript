#!/bin/bash


##You MUST have a public IP address.
##You MUST have a domain with a DNS server
##You MUST have already created a 'A' record for the mediamtx, and pointed it at your public IP address

##If you don't have all of this, do NOT run this script. It will fail.

echo "Install epel-release"
sudo dnf install epel-release -y
echo "Install epel-release complete"
#done

#allow renewal script to be executed
sudo chmod +x mediamtx_renewLECerts.sh

## Install snapd
sudo yum install snapd -y

## Enable snapd
sudo systemctl enable --now snapd.socket

## Create the symbolic link for snap
sudo ln -s /var/lib/snapd/snap /snap

## Add 80/TCP to our public zone and make it permanent
#configure firewall

sudo firewall-cmd --zone=public --permanent --add-port=80/tcp

echo "If the Firewall is disabled, the above will error in red."
echo "If you're running on Digital Ocean, or potentially any other provider, configure the firewall in their app"

## Reload the firewall to accept our changes
sudo firewall-cmd --reload

## View our firewall to verify the change
sudo firewall-cmd --list-all

##wait to avoid "error: too early for operation, device not yet seeded or device model not acknowledge
sudo systemctl restart snapd.seeded.service
snap wait system seed.loaded


## Using snapd install certbot
sudo snap install --classic certbot

## Create the symbolic links to certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

## must be on the correct server, with port 80 open, and DNS setup...

## Begin our certificate signing process for a standalone webserver
sudo certbot certonly --standalone

########Edit this next line
## Verify our newly signed certificate by viewing the contents

read -p 'Certificate Name (FQDN) [ex: tak.domain.com]: ' certNameVar

openssl x509 -text -in /etc/letsencrypt/live/$certNameVar/fullchain.pem -noout


## Conduct a certificate renewal dry run to verify permissions and path
sudo certbot renew --dry-run


echo "complete - wait a minute before checking"

#cd back to previous directory
cd /home/mediamtx

echo "let's make a monthly cron job to renew the LE cert"

echo "modifying the renew script for your domain entered previously"

sed -i 's/certNameVar="PUT_DOMAIN_HERE"/certNameVar='"$certNameVar"'/g' mediamtx_renewLECerts.sh

echo "modified."


#allow renewal script to be executed
#sudo chmod +x /home/mediamtx/mediamtx_renewLECerts.sh
sudo cp mediamtx_renewLECerts.sh /etc/cron.monthly/
echo "copied to /etc/cron.monthly"
echo "the mediamtx LE certificate should be renewed monthly"
