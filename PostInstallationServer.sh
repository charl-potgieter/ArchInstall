
# RUN AS SUDO

echo '--------------------------------------------------------------------------------------------'
echo '			Get and install server program list'
echo '--------------------------------------------------------------------------------------------'

curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/pkg.list.server > /pkg.list.temp
pacman -S --needed - < /pkg.list.temp
rm /pkg.list.temp

printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Copy configuration files from shared folder n local machine'
echo '--------------------------------------------------------------------------------------------'

# mount shared folder and copy files
mkdir /mnt/temp
mount -t vboxsf ConfigFiles /mnt/temp

# Copy the configuration files over to the virtual machine etc folder
cp /mnt/temp/smb.conf /etc/samba/smb.conf

umount /mnt/temp

printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Set file permissions of configuration file'
echo '--------------------------------------------------------------------------------------------'


# Set the file permissions
chmod 644 /etc/samba/smb.conf


printf '\n\n\n'

echo '--------------------------------------------------------------------------------------------'
echo '			Enable daemons'
echo '--------------------------------------------------------------------------------------------'

systemctl enable sshd.service
systemctl enable smb.service
systemctl enable nmb.service
