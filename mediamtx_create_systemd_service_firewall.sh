#!/bin/bash


echo "move the server executable and configuration in global folders"
sudo mv mediamtx /usr/local/bin/
sudo mv mediamtx.yml /usr/local/etc/

echo "create systemf service"
sudo tee /etc/systemd/system/mediamtx.service >/dev/null << EOF
[Unit]
Wants=network.target
[Service]
ExecStart=/usr/local/bin/mediamtx /usr/local/etc/mediamtx.yml
[Install]
WantedBy=multi-user.target
EOF
#done

#enable and start the service"
sudo systemctl daemon-reload
sudo systemctl enable mediamtx
sudo systemctl start mediamtx

# Configure firewall
sudo firewall-cmd --zone=public --permanent --add-port=8554/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8000/udp
sudo firewall-cmd --zone=public --permanent --add-port=8001/udp
sudo firewall-cmd --zone=public --permanent --add-port=1935/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8888/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8889/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8189/udp
sudo firewall-cmd --zone=public --permanent --add-port=8890/udp

# Reload firewall to apply changes
sudo firewall-cmd --reload

echo "+++++++++++++++ ALL DONE! ++++++++++++++++"

