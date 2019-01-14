#!/bin/bash
#
APPD_BASE_DIR=/home/ddr/appdynamics
APPD_VERSION=4.5.2
APPD_CONTROLLER_NAME=controller2
APPD_CONTROLLER_BIN=$APPD_BASE_DIR/$APPD_VERSION/$APPD_CONTROLLER_NAME/controller/bin
APPD_PLATFORM_ADMIN_BIN=$APPD_BASE_DIR/$APPD_VERSION/platform/platform-admin/bin
APPD_PLATFORM_NAME="controller2"
APPD_CONTROLLER_ADMIN=admin
APPD_UNIVERSAL_PWD=welcome1
APPD_LOG_FILE=/var/log/appd-log.txt

controller_start() {
  echo "Starting $APP_NAME "`date`          >> $APPD_LOG_FILE
  $APPD_CONTROLLER_BIN/startController.sh    >> $APPD_LOG_FILE
  echo "$APP_NAME start complete " `date`   >> $APPD_LOG_FILE
}

controller_stop() {
  echo "Stopping $APP_NAME "`date`          >> $APPD_LOG_FILE
  $APPD_CONTROLLER_BIN/stopController.sh     >> $APPD_LOG_FILE
  echo "$APP_NAME stop complete "`date`     >> $APPD_LOG_FILE
}

events_service_start() {
  echo "Starting $APP_NAME "`date`          >> $APPD_LOG_FILE
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh login --user-name  $APPD_CONTROLLER_ADMIN --password $APPD_UNIVERSAL_PWD
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh \
                           submit-job --platform-name $APPD_PLATFORM_NAME --service events-service \
                           --job start    >> $APPD_LOG_FILE
  echo "$APP_NAME start complete " `date`   >> $APPD_LOG_FILE
}

events_service_stop() {
  echo "Stopping $APP_NAME "`date`          >> $APPD_LOG_FILE
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh login --user-name  $APPD_CONTROLLER_ADMIN --password $APPD_UNIVERSAL_PWD
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh \
                           submit-job --platform-name $APPD_PLATFORM_NAME --service events-service \
                           --job stop     >> $APPD_LOG_FILE
  echo "$APP_NAME stop complete "`date`     >> $APPD_LOG_FILE
}

econsole_start() {
  echo "Starting $APP_NAME "`date`          >> $APPD_LOG_FILE
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh start-platform-admin    >> $APPD_LOG_FILE
  echo "$APP_NAME start complete " `date`   >> $APPD_LOG_FILE
}

econsole_stop() {
  echo "Stopping $APP_NAME "`date`          >> $APPD_LOG_FILE
  $APPD_PLATFORM_ADMIN_BIN/platform-admin.sh stop-platform-admin     >> $APPD_LOG_FILE
  echo "$APP_NAME stop complete "`date`     >> $APPD_LOG_FILE
}

all_start() {
  echo "Starting $APP_NAME "`date`          >> $APPD_LOG_FILE
  econsole_start
  events_service_start
  controller_start
}

all_stop() {
  echo "Stopping $APP_NAME "`date`          >> $APPD_LOG_FILE
  controller_stop
  events_service_stop
  econsole_stop
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
