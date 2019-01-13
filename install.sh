#!/bin/bash
#
_installService() {
    SERVICE_NAME=$1
    echo "Installing $SERVICE_NAME"
    sudo cp $SERVICE_NAME.service /etc/systemd/system
    sudo systemctl enable $SERVICE_NAME
}

# Install AppD ctl
sudo cp appd-ctl.sh  /usr/bin
sudo chmod +x /usr/bin/appd-ctl.sh

# Install services
_installService "appd-controller"
_installService "appd-econsole"
_installService "appd-events-service"
