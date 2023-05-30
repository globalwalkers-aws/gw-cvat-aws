#! /usr/bin/bash
# Author: Ye Yint Thu
# Email: yeyintthu@globalwalkers.co.jp

. ./names.config

default_db_port=5432

# ask volume path from user
default_volume=/mnt/$backup_folder
# read mount-volume from user
read -p "Enter existing backup directory to mount[default : $default_volume]: " cvat_vol

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

cvat_data_volume=$volume/$data_volume
cvat_keys_volume=$volume/$keys_volume
cvat_logs_volume=$volume/$logs_volume
cvat_events_volume=$volume/$events_volume


echo "Volume directory has been re-initialized as $volume"

# read aws RDS database endpoint
read -p "Enter aws RDS postgres db instance endpoint[****.rds.amazonaws.com]: " db_instance_endpoint

# read aws RDS db name
read -p "Enter aws RDS postgres db name: " db_name

# read aws RDS db's user name
read -p "Enter aws RDS postgres db's user name: " db_user_name

# read aws RDS db's password
read -sp "Enter aws RDS postgres db's password: " db_password

echo

# read aws RDS db's port number
read -p "Enter aws RDS postgres db's port [ default: $default_db_port ]: " db_port

if [ -z "${db_port}" ]
then
   port_number=$default_db_port
else
   port_number=$db_port
fi

cd ..
# spin cvat containers up
echo "Spining cvat docker containers up..."

CVAT_DATA_VOLUME=$cvat_data_volume \
CVAT_KEYS_VOLUME=$cvat_keys_volume \
CVAT_LOGS_VOLUME=$cvat_logs_volume \
CVAT_EVENTS_VOLUME=$cvat_events_volume \
DB_ENDPOINT=$db_instance_endpoint \
DB_NAME=$db_name \
DB_USER_NAME=$db_user_name \
DB_PWD=$db_password \
DB_PORT=$db_port \
docker compose up -d