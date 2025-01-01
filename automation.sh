#!/bin/bash

# Update and upgrade the system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install necessary packages
sudo apt-get install -y nfs-common awscli

# Configure NFS mount
NFS_SERVER="efs-nfs-server.gerardrecinto.com"
NFS_MOUNT="/mnt/nfs"
sudo mkdir -p $NFS_MOUNT
sudo mount -t nfs $NFS_SERVER:/export $NFS_MOUNT

# Configure AWS S3 CLI
AWS_BUCKET="s3://gerardrecinto"
AWS_REGION="us-west-2"
aws configure set default.region $AWS_REGION

# Backup database and upload to S3
DB_NAME="mysql"
DB_USER="db_admin"
DB_PASS="${REDACTED}"
BACKUP_FILE="/tmp/${DB_NAME}_backup.sql"

mysqldump -u $DB_USER -p $DB_PASS $DB_NAME > $BACKUP_FILE
aws s3 cp $BACKUP_FILE $AWS_BUCKET

# Restore database from S3
aws s3 cp $AWS_BUCKET/$BACKUP_FILE $BACKUP_FILE
mysql -u $DB_USER -p $DB_PASS $DB_NAME < $BACKUP_FILE

# Automate tasks using cron
CRON_JOB="0 2 * * * /path/to/backup_script.sh"
(crontab -l ; echo "$CRON_JOB") | crontab -

echo "Automation script executed successfully!"
