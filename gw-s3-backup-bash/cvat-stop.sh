#! /usr/bin/bash
# Author: Ye Yint Thu
# Email: yeyintthu@globalwalkers.co.jp

. ./names.config

cvat_db_volume=$volume/$db_volume
cvat_data_volume=$volume/$data_volume
cvat_keys_volume=$volume/$keys_volume
cvat_logs_volume=$volume/$logs_volume
cvat_events_volume=$volume/$events_volume

# spin cvat containers down
echo "Spining cvat docker containers down..."

CVAT_DB_VOLUME=$cvat_db_volume \
CVAT_DATA_VOLUME=$cvat_data_volume \
CVAT_KEYS_VOLUME=$cvat_keys_volume \
CVAT_LOGS_VOLUME=$cvat_logs_volume \
CVAT_EVENTS_VOLUME=$cvat_events_volume \
docker compose down
# remove docker volumes
docker volume rm $(docker volume ls -q)
