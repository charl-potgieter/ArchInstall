#!/bin/bash


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
echo '			Disk partitioning, formatting and mount'
echo '--------------------------------------------------------------------------------------------'

parted /dev/sda mklabel msdos
parted /dev/sda mkpart primary ext4 1MiB 100%
parted /dev/sda set 1 boot on
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
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
echo '--------------------------------------------------------------------------------------------'

# GRUB Bootloader
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Get and install server program list'
echo '--------------------------------------------------------------------------------------------'

curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/pkg.list.server > pkg.list.temp
pacman -S --needed - < pkg.list.temp
rm pkg.list.temp


echo '--------------------------------------------------------------------------------------------'
echo '			Enable daemons'
echo '--------------------------------------------------------------------------------------------'

systemctl enable sshd.service
systemctl enable smb.service
systemctl enable nmb.service



echo '--------------------------------------------------------------------------------------------'
echo '        Select the  root password'
echo '--------------------------------------------------------------------------------------------'
printf '\n'
passwd


echo '--------------------------------------------------------------------------------------------'
echo '        Allow editing of sudo file'
echo '--------------------------------------------------------------------------------------------'

printf '\n'
echo 'editing with visudo.   Uncomment  %wheel    ALL=(ALL) ALL'
read -p "Press enter to continue... "
visudo


echo '--------------------------------------------------------------------------------------------'
echo '        Add user charl (with home directory) and set password and add to wheel group'
echo '--------------------------------------------------------------------------------------------'

useradd -m charl
passwd charl
gpasswd -a charl wheel


exit # to leave the chroot
EOF
#######################################################################################################################

# run the script created above
chmod 755 /mnt/install_script_part2.sh
arch-chroot /mnt /install_script_part2.sh
