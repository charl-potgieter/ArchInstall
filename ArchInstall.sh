#!/bin/bash

echo '--------------------------------------------------------------------------------------------'
echo 'Ensure device for installation is mounted in /mnt before continuing'
echo 'Can use Diskprepare.sh in this repository in virtualbox'
read -p 'If not press ctrl-C to cancel, enter to continue'
echo '--------------------------------------------------------------------------------------------'


# Display network interfaces
echo '--------------------------------------------------------------------------------------------'
echo '			Display network interfaces'
echo '--------------------------------------------------------------------------------------------'
printf '\n'
ip addr show
printf '\n\n\n'



echo '--------------------------------------------------------------------------------------------'
echo '			Read details from user'
echo '--------------------------------------------------------------------------------------------'

read -p "Enter host name : " HOSTNAME
# read -p "Enter IP address : " IPADDRESS
read -p "Enter network interface e.g. enp0s3, eth0 : " INTERFACE
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Install the base package'
echo '--------------------------------------------------------------------------------------------'

pacstrap /mnt base
printf '\n\n\n'



echo '--------------------------------------------------------------------------------------------'
echo '			Generate fstab'
echo '--------------------------------------------------------------------------------------------'

genfstab -U /mnt >> /mnt/etc/fstab
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Generate a here document script to run in chroot'
echo '--------------------------------------------------------------------------------------------'


#######################################################################################################################
cat <<EOF > /mnt/install_script_part2.sh

echo '--------------------------------------------------------------------------------------------'
echo '			Update clock and set time zones'
echo '--------------------------------------------------------------------------------------------'

timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Set localisation'
echo '--------------------------------------------------------------------------------------------'

cp /etc/locale.gen /etc/locale.gen.backup.auto
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_AU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_AU.UTF-8" > /etc/locale.conf
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Network configuration'
echo '--------------------------------------------------------------------------------------------'

echo $HOSTNAME > /etc/hostname

echo "127.0.0.1             localhost" >  /etc/hosts
echo  "::1                   localhost" >> /etc/hosts
echo  127.0.1.1 "    " $HOSTNAME".localdomain   " $HOSTNAME >> /etc/hosts

ip link set $INTERFACE up
systemctl enable dhcpcd@$INTERFACE.service
printf '\n\n\n'



echo '--------------------------------------------------------------------------------------------'
echo '			Install and configure GRUB'
echo '      NOTE THIS IS FOR BIOS INSTALL ONLY'
read -p 'If not press ctrl-C to cancel, enter to continue'
echo '--------------------------------------------------------------------------------------------'

# GRUB Bootloader
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

printf '\n\n\n'




echo '--------------------------------------------------------------------------------------------'
echo '			Setup git'
echo '--------------------------------------------------------------------------------------------'

read -p "Enter git name : " GITNAME
read -p "Enter git email address : " GITEMAIL

git config --global user.name  "$GITNAME"
git config --global user.email "$GITEMAIL"

printf '\n\n\n'



echo '--------------------------------------------------------------------------------------------'
echo '			Install virtualbox guest additions'
echo '--------------------------------------------------------------------------------------------'

read -p "Enter (1) for virtualbox-guest-utils-nox, (2) for virtualbox-guest-utils : " VBOX

if [[ $VBOX -eq 1 ]]; then
	sudo pacman -S virtualbox-guest-utils-nox
else
	sudo pacman -S virtualbox-guest-utils
fi





echo '--------------------------------------------------------------------------------------------'
echo '        Select the  root password'
echo '--------------------------------------------------------------------------------------------'
printf '\n'
passwd




exit # to leave the chroot
EOF
#######################################################################################################################

# run the script created above
chmod 755 /mnt/install_script_part2.sh
arch-chroot /mnt /install_script_part2.sh
