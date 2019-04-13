#!/bin/bash


################################################################
#
# To Do
# Maybe rethink the static IP address thing - try DHCPCD 
# Add a date&timestamp to the /etc/locale.gen backup file
# 
################################################################


# Boot live iso and download this script using curl as below
# curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/ArchInstall.sh > installscript.sh
# make executable with chmod 755 installscipt.sh
# run using below to direct stdout and stderr to outfile to review as messages quickly scroll of screen
# ./installscript.sh 2>&1 | tee outfile


# Display network interfaces
echo '-------------------------------------------------------'
echo '	Network interfaces as below'
echo '-------------------------------------------------------'
echo '\n\n'
ip addr show
echo '\n\n'


# Read hostname and ip address from keyboard
read -p "Enter host name : " HOSTNAME
# read -p "Enter IP address : " IPADDRESS
read -p "Enter network interface e.g. enp0s3, eth0 : " INTERFACE

	
# Disk partitioning and formatting
parted /dev/sda mklabel msdos
parted /dev/sda mkpart primary ext4 1MiB 100%
parted /dev/sda set 1 boot on
mkfs.ext4 /dev/sda1

# Mount the partition
mount /dev/sda1 /mnt

# Install base package
pacstrap /mnt base

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot into new system
arch-chroot /mnt


# Update clock and set time zones
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc

# Set localisation
cp /etc/locale.gen /etc/locale.gen.backup.auto
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_AU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_AU.UTF-8" > /etc/locale.conf


#Network configuration
echo $HOSTNAME > /etc/hostname

echo "127.0.0.1             localhost" >  /etc/hosts
echo  "::1                   localhost" >> /etc/hosts
echo  127.0.1.1 "    " $HOSTNAME".localdomain   " $HOSTNAME >> /etc/hosts


ip link set $INTERFACE up
systemctl enable dhcpcd@$INTERFACE.service

# GRUB Bootloader
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

