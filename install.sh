#!/bin/bash
#
_installService() {
    SERVICE_NAME=$1
    echo "Installing $SERVICE_NAME"
    sudo systemctl disable $SERVICE_NAME

    sudo cp $SERVICE_NAME.service /etc/systemd/system
    sudo systemctl enable $SERVICE_NAME
}

_validateEnvironmentVars() {
  VAR_LIST=("$@") # rebuild using all args
  for i in "${VAR_LIST[@]}"; do
     [ -z ${!i} ] && { echo "Environment variable not set: $i"; ERROR="1"; }
  done
  [ "$ERROR" == "1" ] && { echo "Exiting"; exit 1; }
}

_validateEnvironmentVars APPD_BASE_DIR APPD_CONTROLLER_NAME APPD_CONTROLLER_ADMIN APPD_UNIVERSAL_PWD

# Install AppD ctl
sudo cp appd-ctl.sh  /usr/bin
sudo chmod +x /usr/bin/appd-ctl.sh

# Create envvar file
env | grep "APPD_" > appd-ctl-envars.sh
sudo mkdir /etc/appdynamics
sudo cp -f appd-ctl-envars.sh /etc/appdynamics/appd-ctl-envars.sh

echo "Installing for base dir: $APPD_BASE_DIR"

# Install services
_installService "appd-controller"
_installService "appd-econsole"
_installService "appd-events-service"
