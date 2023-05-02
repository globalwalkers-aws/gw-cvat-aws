#! /usr/bin/bash
# Author: Ye Yint Thu
# Email: yeyintthu@globalwalkers.co.jp

. ./names.config

# ask volume path from user
default_volume=/mnt/$backup_folder
# read mount-volume from user
read -p "Enter existing volume to mount[default : $default_volume]: " cvat_vol

if [ -z "${cvat_vol}" ]
then
   volume=$default_volume
else
   volume=$cvat_vol
fi

if [ ! -d "$volume" ]; then
  echo "ERROR: $volume does not exist."
  exit 1
fi

cvat_db_volume=$volume/$db_volume
cvat_data_volume=$volume/$data_volume
cvat_keys_volume=$volume/$keys_volume
cvat_logs_volume=$volume/$logs_volume
cvat_events_volume=$volume/$events_volume


cd ..
# spin cvat containers up
echo "Spining cvat docker containers up..."

CVAT_DB_VOLUME=$cvat_db_volume \
CVAT_DATA_VOLUME=$cvat_data_volume \
CVAT_KEYS_VOLUME=$cvat_keys_volume \
CVAT_LOGS_VOLUME=$cvat_logs_volume \
CVAT_EVENTS_VOLUME=$cvat_events_volume \
docker compose up -d
