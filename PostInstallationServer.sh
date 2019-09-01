# RUN AS SUDO


echo '--------------------------------------------------------------------------------------------'
echo '			Systems upgrade'
echo '--------------------------------------------------------------------------------------------'

pacman -Syu
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Get and install server program list'
echo '--------------------------------------------------------------------------------------------'

curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/pkg.list.server > /pkg.list.temp
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
echo '			Copy configuration and user files from shared folder on local machine'
echo '--------------------------------------------------------------------------------------------'

# The copying of users inspired by the below
# https://www.cyberciti.biz/faq/howto-move-migrate-user-accounts-old-to-new-server/

# mount shared folder and copy files
mkdir /mnt/temp
mount -t vboxsf ConfigFiles /mnt/temp


# Copy the configuration and user files over to the virtual machine etc folder
cp /mnt/temp/smb.conf /etc/samba/smb.conf
cp /mnt/temp/fstab_live_system /etc/fstab_live_system
cat /mnt/temp/passwd.mig >> /etc/passwd
cat /mnt/temp/group.mig >> /etc/group
cat /mnt/temp/shadow.mig >> /etc/shadow
cp /mnt/temp/gshadow.mig /etc/gshadow
cp /mnt/temp/smbpasswd /usr/bin/smbpasswd



printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Set file permissions of configuration file'
echo '--------------------------------------------------------------------------------------------'


# Set the file permissions
chmod 644 /etc/samba/smb.conf
chmod 644 /etc/group
chmod 600 /etc/shadow
chmod 600 /etc/gshadow
chmod 755 /usr/bin/smbpasswd
chmod 644 /etc/fstab_live_system


printf '\n\n\n'



echo '--------------------------------------------------------------------------------------------'
echo '			Create directories for mounting data and backups in the live system'
echo '--------------------------------------------------------------------------------------------'

mkdir /srv/samba
mkdir /mnt/backups/usb_server_os
mkdir /mnt/backups/mirror_overnight
mkdir /mnt/backups/snapshots


echo '--------------------------------------------------------------------------------------------'
echo '			Copy public key from shared folder on local pc'
echo '--------------------------------------------------------------------------------------------'

# below user needs to have already have been copied across in config files
read -p "Enter user for home folder creation for ssh (User needs to exist in config files) : " SSHUSER
mkdir /home/$SSHUSER
mkdir /home/$SSHUSER/.ssh
cat /mnt/temp/id_rsa.pub >> /home/$SSHUSER/.ssh/authorized_keys

chown $SSHUSER:$SSHUSER /home/$SSHUSER
chown $SSHUSER:$SSHUSER /home/$SSHUSER/.ssh
chown $SSHUSER:$SSHUSER /home/$SSHUSER/.ssh/authorized_keys
chmod 700 /home/$SSHUSER/.ssh
chmod 600 /home/$SSHUSER/.ssh/authorized_keys


printf '\n\n\n'



echo '--------------------------------------------------------------------------------------------'
echo '			Disable ssh passwords'
echo '--------------------------------------------------------------------------------------------'

echo 'set PasswordAuthentication no in sshd_config'
read -p "Press enter to continue and make above change... "
vim /etc/ssh/sshd_config

printf '\n\n\n'



echo '--------------------------------------------------------------------------------------------'
echo '			Unmount shared folder'
echo '--------------------------------------------------------------------------------------------'

umount /mnt/temp
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Enable and start daemons'
echo '--------------------------------------------------------------------------------------------'

systemctl enable sshd.service
systemctl enable smb.service
systemctl enable nmb.service

systemctl start sshd.service
systemctl start smb.service
systemctl start nmb.service
