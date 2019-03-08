#!/bin/bash
#
#
# Maintainer: David Ryder
#
# Reference
# https://docs.appdynamics.com/display/PRO45/Start+or+Stop+the+Controller

# Source envvars
. /etc/appdynamics/appd-ctl-envars.sh
APPD_CONTROLLER_BIN=$APPD_BASE_DIR/$APPD_CONTROLLER_NAME/controller/bin
APPD_PLATFORM_ADMIN_BIN=$APPD_BASE_DIR/platform/platform-admin/bin
APPD_PLATFORM_NAME=$APPD_CONTROLLER_NAME


_appd_ctl_service() {
  SERVICE_NAME=$1
  COMMAND=$2
  TIMEOUT_MINUTES=${1:-"16"}
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

all_check() {
  # Check Analyics Agent
  curl http://localhost:9091/healthcheck?pretty=true

  # Check Enconsole
  curl localhost:9191/service/version

  # Check controller
  curl http://localhost:8090/controller/rest/serverstatus
}

SERVICE_NAME=$1
SERVICE_CMD=$2
APP_NAME="AppDynamics "$SERVICE_NAME
echo "Commands : ""$SERVICE_NAME"_"$SERVICE_CMD"
case $SERVICE_NAME in
  econsole)       "$SERVICE_NAME"_"$SERVICE_CMD" ;;
  events_service) "$SERVICE_NAME"_"$SERVICE_CMD" ;;
  controller)     "$SERVICE_NAME"_"$SERVICE_CMD" ;;
  all)            "$SERVICE_NAME"_"$SERVICE_CMD" ;;
  *)              echo "Commands unknown: ""$SERVICE_NAME"_"$SERVICE_CMD"
esac
