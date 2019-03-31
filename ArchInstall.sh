#!/bin/bash

#Update the system clock
timedatectl set-ntp true

#Set Sydney time zone
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc
