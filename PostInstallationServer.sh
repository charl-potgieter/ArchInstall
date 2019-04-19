################################# TODO ####################################################

# AMMEND THE IMPORTED PASSWORD FILES TO SET PASSWORD FOR ALL USERS TO DEFAULT PASSWORD THAT CAN 
# THEN BE CHANGED LATER FOR SECURITY REASONS, RAHTER THAN SAVING PASSWORDS.  THAT WAY I CAN MOVE 
# THE CONFIGURATION FILES BACK TO DROPBOX


# RUN AS SUDO

pacman -Syu

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

#######!!!!!!!!!! CHANGE THE PASSWORDS HERE TO BE DEFAULT PASSWORD AND THEN CHANGE LATE !!!!!!!!!!!!! ########
### TO PREVENT THE INSECURE STORAGE OF PASSWORDS #########
### CHANGE THE SHARE FOLDER LOCATION, OR SHOULD I EVEN POTENTIALLY MOVE TO GITHUB ??? ########################

# Copy the configuration and user files over to the virtual machine etc folder
cp /mnt/temp/smb.conf /etc/samba/smb.conf
cat /mnt/temp/passwd.mig >> /etc/passwd
cat /mnt/temp/group.mig >> /etc/group
cat /mnt/temp/shadow.mig >> /etc/shadow
cp /mnt/temp/gshadow.mig /etc/gshadow

umount /mnt/temp

printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Set file permissions of configuration file'
echo '--------------------------------------------------------------------------------------------'


# Set the file permissions
chmod 644 /etc/samba/smb.conf
chmod 644 /etc/group
chmod 600 /etc/shadow
chmod 600 /etc/gshadow



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
