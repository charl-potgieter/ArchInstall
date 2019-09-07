#!/bin/bash



echo '--------------------------------------------------------------------------------------------'
echo '			Systems upgrade'
echo '--------------------------------------------------------------------------------------------'

pacman -Syu
printf '\n\n\n'



echo '--------------------------------------------------------------------------------------------'
echo '			Get and install GUI program list'
echo '--------------------------------------------------------------------------------------------'

curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/pkg.list.gui > /pkg.list.temp
pacman -S --needed - < /pkg.list.temp
rm /pkg.list.temp

printf '\n\n\n'




echo '--------------------------------------------------------------------------------------------'
echo '        Allow editing of sudo file'
echo '--------------------------------------------------------------------------------------------'

printf '\n'
echo 'editing with visudo.   Uncomment  %wheel    ALL=(ALL) ALL'
read -p "Press enter to continue... "
EDITOR=vim visudo
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Create new user and add to wheel'
echo '--------------------------------------------------------------------------------------------'

read -p "Enter user name (to be added to wheel group and home dir created) : " MYUSERNAME
useradd -m $MYUSERNAME
gpasswd -a $MYUSERNAME wheel
printf '\n\n\n'

echo '--------------------------------------------------------------------------------------------'
echo '			Set user password'
echo '--------------------------------------------------------------------------------------------'

passwd $MYUSERNAME
printf '\n\n\n'





echo '--------------------------------------------------------------------------------------------'
echo '			Mount shared folder named Config_Files_GUI and copy config files'
echo '--------------------------------------------------------------------------------------------'

printf '\n'
echo 'Ensure a virtualbox shared folder named Config_Files_GUI is set up for'
echo 'copying across relevant configuration files not stored in Github repo.'
read -p "Press enter to continue... "

mount -t vboxsf -o gid=vboxsf Config_Files_GUI /mnt
cat /mnt/fstab >> /etc/fstab
umount /mnt

printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Refresh fstab'
echo '--------------------------------------------------------------------------------------------'

mount -a
printf '\n\n\n'




echo '--------------------------------------------------------------------------------------------'
echo '			Make directories for mounting samba shares'
echo '--------------------------------------------------------------------------------------------'

mkdir /home/$MYUSERNAME/Documents_Charl
mkdir /home/$MYUSERNAME/Documents_Kerrie
mkdir /home/$MYUSERNAME/Documents_Dylan
mkdir /home/$MYUSERNAME/Documents_Jared
mkdir /home/$MYUSERNAME/Pictures
mkdir /home/$MYUSERNAME/HomeVideos
mkdir /home/$MYUSERNAME/Videos
mkdir /home/$MYUSERNAME/Music
mkdir /home/$MYUSERNAME/ZZZ_Backup_Cloud_Drives
mkdir /home/$MYUSERNAME/ZZZ_Backup_USB_ServerOS
mkdir /home/$MYUSERNAME/ZZZ_BackupMirrorOvernight
mkdir /home/$MYUSERNAME/ZZZ_BackupSnapshots


echo '--------------------------------------------------------------------------------------------'
echo '			Change ownership of above directories'
echo '--------------------------------------------------------------------------------------------'

chown charl:charl /home/$MYUSERNAME/Documents_Charl
chown charl:charl /home/$MYUSERNAME/Documents_Kerrie
chown charl:charl /home/$MYUSERNAME/Documents_Dylan
chown charl:charl /home/$MYUSERNAME/Documents_Jared
chown charl:charl /home/$MYUSERNAME/Pictures
chown charl:charl /home/$MYUSERNAME/HomeVideos
chown charl:charl /home/$MYUSERNAME/Videos
chown charl:charl /home/$MYUSERNAME/Music
chown charl:charl /home/$MYUSERNAME/ZZZ_Backup_Cloud_Drives
chown charl:charl /home/$MYUSERNAME/ZZZ_Backup_USB_ServerOS
chown charl:charl /home/$MYUSERNAME/ZZZ_BackupMirrorOvernight
chown charl:charl /home/$MYUSERNAME/ZZZ_BackupSnapshots



echo '--------------------------------------------------------------------------------------------'
echo '			SSH credentials file'
echo '--------------------------------------------------------------------------------------------'


echo "username=myuser" > /etc/samba/credentials/share
echo "password=mypass" >> /etc/samba/credentials/share
printf '\n'

read -p "Press enter to edit credentials file... "
vim /etc/samba/credentials/share
printf '\n'

# Set credential file ownership and permissions
chown root:root /etc/samba/credentials
chmod 700 /etc/samba/credentials
chmod 600 /etc/samba/credentials/share


