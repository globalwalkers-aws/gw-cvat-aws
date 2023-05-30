# Running CVAT 1st Architecture on AWS
This document shows how to start/stop CVAT 1st architecture on AWS EC2 instance and how to run backup(to S3) script manually.

## Steps
### Pre-requied steps
- Gain admin access,
```bash
sudo su
```
- Inside Ec2 instance, navigate to **/gw-cvat/gw-cvat-aws** by
```bash
cd /gw-cvat/gw-cvat-aws
```
- Export CVAT_HOST env variable as your EC2 instance Public IPv4 address by
```bash
export CVAT_HOST=[Your Public IPv4 address]
```
### How to start CVAT
- Navigate to **gw-backup-bash** directory
```bash
cd gw-backup-bash
```
- [Option-1] If you want to start CVAT with new backup direcoty (if this is the first time you run CVAT),
```bash
./cvat-init-run.sh
```
- [Option-2] If you want to re-start previous CVAT system (Like you have existing backup directory from previous CVAT running),
```bash
./cvat-run.sh
```
### How to stop CVAT
- Simply run the following to stop CVAT system and remove0 running CVAT docker containers as well as docker volumes
```bash
./cvat-stop.sh
```
### How to run backup script manually
- From **/gw-cvat/gw-cvat-aws/** directory, run
```bash
./gw-backup-bash/backup_cvat_data_to_s3.sh {CVAT-BACKUP-DIRECTORY}
```
where CVAT-BACKUP-DIRECTORY is the directory where you initialize on staring CVAT. For example, default **/mnt/cvat-backups** that you have found when you run [cvat-init-run.sh](./gw-s3-backup-bash/cvat-init-run.sh) or [cvat-run.sh](./gw-s3-backup-bash/cvat-run.sh)