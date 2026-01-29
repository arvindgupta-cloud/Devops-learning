#!/bin/bash

<<info

This a sample file for creating  backup file

info

TIMESTAMP=$(TZ="Asia/Kolkata" date +%Y%m%d_%H%M%S)

zip -r /home/student-04-eac22dea64bc/backup/$TIMESTAMP.data.zip /home/student-04-eac22dea64bc/hello 


# Upload to GCS
gsutil cp "/home/student-04-eac22dea64bc/backup/$TIMESTAMP.data.zip" "gs://qwiklabs-gcp-02-b9ef69bd3f80/backup/"

echo "Backup created and uploaded in storage bucket."
