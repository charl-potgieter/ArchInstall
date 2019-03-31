#!/bin/bash

#Update the system clock
timedatectl set-ntp true

#Set Sydney time zone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
