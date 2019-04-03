#!/bin/bash


################################################################
#
# To Do
# Maybe rethink the static IP address thing - try DHCPCD 
# 
################################################################


# Read hostname and ip address from keyboard
read -p "Enter host name : " HOSTNAME
# read -p "Enter IP address : " IPADDRESS
read -p "Enter network interface e.g. enp0s3, eth0 : " INTERFACE


# Update clock and set time zones
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc

# Set localisation
cp /etc/locale.gen /etc/locale.gen.backup.auto
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "en_AU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_AU.UTF-8" > /etc/locale.conf


#Network configuration
echo $HOSTNAME > /etc/hostname

echo "127.0.0.1             localhost" >  /etc/hosts
echo  "::1                   localhost" >> /etc/hosts
echo  127.0.1.1 "    " $HOSTNAME".localdomain   " $HOSTNAME >> /etc/hosts


ip link set $INTERFACE up
