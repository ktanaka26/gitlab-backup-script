#!/bin/bash

# Directory of GitLab backup files
GITLAB_BACKUPS="/var/opt/gitlab/backups"

# Google Drive's Directory ID
GDRIVE_DIRID="YOUR_GDRIVE_DIRID"

# Path of GDrive config.
GDRIVE_CONFIG="/etc/gitlab/gdrive"



echo "Starting GitLab Backup Script"
echo

echo "Backup directory: $GITLAB_BACKUPS"
echo
if [ ${EUID:-${UID}} != 0 ]; then
    echo "Permission denied."
    exit
fi

echo "Execute gitlab-rake gitlab:backup:create"
echo
/usr/bin/gitlab-rake gitlab:backup:create
echo
echo


echo "Get filename"
TARGET_FILENAME_FULLPATH=$(ls -dt $GITLAB_BACKUPS/* | head -1)
TARGET_FILENAME=$(basename $TARGET_FILENAME_FULLPATH)
echo
echo

echo "Target File: $TARGET_FILENAME"
echo
echo

echo "Compressing backup"
COMPRESS_TYPE=bz2
#/usr/bin/gzip -c TARGET_FILENAME_FULLPATH > /tmp/$TARGET_FILENAME.gz
/usr/bin/bzip2 -c --best $TARGET_FILENAME_FULLPATH > /tmp/$TARGET_FILENAME.$COMPRESS_TYPE
UPLOAD_FILENAME_FULLPATH=/tmp/$TARGET_FILENAME.$COMPRESS_TYPE
UPLOAD_FILENAME=$(basename $UPLOAD_FILENAME_FULLPATH)
echo
echo


echo "Uploading file $UPLOAD_FILENAME"
drive -c $GDRIVE_CONFIG upload -p $GDRIVE_DIRID $UPLOAD_FILENAME_FULLPATH
echo
echo


echo "Removing local compressed file $UPLOAD_FILENAME"
rm $UPLOAD_FILENAME_FULLPATH
echo
echo


echo "Done."
echo
