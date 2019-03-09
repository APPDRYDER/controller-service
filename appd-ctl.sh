#!/bin/bash
#
#
# Maintainer: David Ryder
#
# Reference
# https://docs.appdynamics.com/display/PRO45/Start+or+Stop+the+Controller

# Source envvars
. /etc/appdynamics/appd-ctl-envars.sh



_validateEnvironmentVars() {
  VAR_LIST=("$@") # rebuild using all args
  for i in "${VAR_LIST[@]}"; do
     [ -z ${!i} ] && { echo "Environment variable not set: $i"; ERROR="1"; }
  done
  [ "$ERROR" == "1" ] && { echo "Exiting"; exit 1; }
}

_appd_ctl_service() {
  SERVICE_NAME=$1
  COMMAND=$2
  TIMEOUT_MINUTES=${3:-"16"}
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh login --user-name  $APPD_CONTROLLER_ADMIN --password $APPD_UNIVERSAL_PWD
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh submit-job \
                    --platform-name $APPD_PLATFORM_NAME --service $SERVICE_NAME \
                    --job $COMMAND
  # --args controllerProcessTimeoutInMin=TIMEOUT_MINUTES
}

controller_start() {
  echo "Starting $APP_NAME "`date`
  #_appd_ctl_service controller start
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh start-controller-appserver --with-db
}

controller_stop() {
  echo "Stopping $APP_NAME "`date`
  #_appd_ctl_service controller stop
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh stop-controller-appserver --with-db
}

events_service_start() {
  echo "Starting $APP_NAME "`date`
  _appd_ctl_service events-service start
}

events_service_stop() {
  echo "Stopping $APP_NAME "`date`
    _appd_ctl_service events-service stop
}

econsole_start() {
  echo "Starting $APP_NAME "`date`
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh start-platform-admin
}

econsole_stop() {
  echo "Stopping $APP_NAME "`date`
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh stop-platform-admin
}

all_start() {
  echo "Starting $APP_NAME "`date`
  sudo systemctl start appd-econsole
  sudo systemctl start appd-events-service
  sudo systemctl start appd-controller
}

all_stop() {
  echo "Stopping $APP_NAME "`date`
  sudo systemctl stop appd-controller
  sudo systemctl stop appd-events-service
  sudo systemctl stop appd-econsole
}

all_status() {
  sudo systemctl status appd-econsole
  sudo systemctl status appd-events-service.service
  sudo systemctl status appd-controller
}

all_check() {
  # Check Analyics Agent
  curl http://localhost:9091/healthcheck?pretty=true

  # Check Enconsole
  curl localhost:9191/service/version

  # Check controller
  curl http://localhost:8090/controller/rest/serverstatus
}

commands_help() {
  echo "econsole stop | start"
  echo "events_service stop | start"
  echo "controller stop | start"
  echo "all stop | start"
  echo "all status"
}

_validateEnvironmentVars APPD_BASE_DIR APPD_CONTROLLER_NAME APPD_CONTROLLER_ADMIN APPD_UNIVERSAL_PWD

APPD_CONTROLLER_BIN=$APPD_BASE_DIR/$APPD_CONTROLLER_NAME/controller/bin
APPD_PLATFORM_ADMIN_BIN=$APPD_BASE_DIR/platform/platform-admin/bin
APPD_PLATFORM_NAME=$APPD_CONTROLLER_NAME


SERVICE_NAME=$1
SERVICE_CMD=$2
APP_NAME="AppDynamics "$SERVICE_NAME
echo "Commands : ""$SERVICE_NAME"_"$SERVICE_CMD"
case $SERVICE_NAME in
  econsole)       "$SERVICE_NAME"_"$SERVICE_CMD" ;;
  events_service) "$SERVICE_NAME"_"$SERVICE_CMD" ;;
  controller)     "$SERVICE_NAME"_"$SERVICE_CMD" ;;
  all)            "$SERVICE_NAME"_"$SERVICE_CMD" ;;
  *)              commands_help                 ;;
esac

exit 0
