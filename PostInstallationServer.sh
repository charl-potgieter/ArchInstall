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
echo '			Create directories for mounting data and backups in the live system'
echo '--------------------------------------------------------------------------------------------'

mkdir /srv/samba
mkdir /mnt/backups
mkdir /mnt/backups/usb_server_os
mkdir /mnt/backups/mirror_overnight
mkdir /mnt/backups/snapshots



echo '--------------------------------------------------------------------------------------------'
echo '			Disable ssh passwords'
echo '--------------------------------------------------------------------------------------------'

echo 'set PasswordAuthentication no in sshd_config'
read -p "Press enter to continue and make above change... "
vim /etc/ssh/sshd_config

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
