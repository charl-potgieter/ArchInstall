#!/bin/bash

HOSTNAME = "ArchVirtTest"
IPADDRESS = "TBA"


# Update clock and set time zones
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc

# Set localisation
echo "en_US.UTF-8 UTF-8" >> /etc/locale.conf
echo "en_AU.UTF-8 UTF-8" >> /etc/locale.conf
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf


#Network configuration
echo $HOSTNAME > /etc/hostname

echo "127.0.0.1             localhost" >  /etc/hosts
echo  "::1                   localhost" >> /etc/hosts
echo  $IPADDRESS "    " $HOSTNAME ".localdomain   " $HOSTNAME >> /etc/hosts
