#!/bin/bash
#
#
SRC_DIR=${1:-"NONE"}
SRC_DIR=${PWD}

if [ ! -d $SRC_DIR ]; then
    echo "Source dir is missing: "$SRC_DIR
    pwd
    exit 1
fi

# ${PWD##*/}
# Sync to Ravello
TARGET_HOST=sys1controller451-dryderdockk8senv1-usw78v34.srv.ravcloud.com
TARGET_USER=ddr
TARGET_DIR=/home/ddr/
SSH_KEY=~/.ssh/ddr-04012018


#echo ""
#echo "Synching $SRC_DIR to $TARGET_HOST at $TARGET_DIR"
#rsync -vraH $SRC_DIR -e ssh -i $SSH_KEY $TARGET_USER@$TARGET_HOST:$TARGET_DIR


TARGET_HOST=dryderubuntu1804do-dryderdockk8senv1-bsv81axw.srv.ravcloud.com
TARGET_USER=ddr
TARGET_DIR=/home/ddr/
SSH_KEY=~/.ssh/ddr-04012018
echo ""
echo "Synching $SRC_DIR to $TARGET_HOST at $TARGET_DIR"
rsync -vraH $SRC_DIR -e ssh -i $SSH_KEY $TARGET_USER@$TARGET_HOST:$TARGET_DIR
