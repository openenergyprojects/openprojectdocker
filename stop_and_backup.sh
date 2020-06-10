#!/bin/bash

#set -x

DATE=`date +'%Y%m%d_%H%M%S'`
BACKUP_ROOT_DIR=./bkp/
THIS_BACKUP_DIR=${BACKUP_ROOT_DIR}/${DATE}
sudo mkdir -p ${THIS_BACKUP_DIR}/

$? && echo "Error on mkdir, exiting now!" && exit 1

echo "stopping the server in 5 seconds!"
sleep 5
docker stop openprojectdocker

echo "starting backup"
sudo cp -rp pgdata static ${THIS_BACKUP_DIR}/

echo "backup is done, you may run the restart.sh now!"

