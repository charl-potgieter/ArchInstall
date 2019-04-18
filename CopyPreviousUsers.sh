#!/bin/bash

##########################################################################################
#
#     Copies users from current machine to /exported.users folder
#     Needs to be run as sudo
#     Run this on any old machine to get users for import into new machine
#     Inspired by below
#     https://www.cyberciti.biz/faq/howto-move-migrate-user-accounts-old-to-new-server/
#
##########################################################################################


if [ -d "/exported.users" ]; then
  echo 'Folder /exported.users already exists.  Aborting.'
  exit 1
fi

export UGIDLIMIT=500
mkdir /exported.users

awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd > /exported.users/passwd.mig
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group > /exported.users/group.mig
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > /exported.users/shadow.mig
cp /etc/gshadow /exported.users/gshadow.mig
