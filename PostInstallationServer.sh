
# RUN AS SUDO

pacman -S virtualbox-guest-utils-nox

# mount shared folder and copy files
mkdir /mnt/temp
mount -t vboxsf ConfigFiles /mnt/temp

# Copy the configuration files over to the virtual machine etc folder
cp /mnt/temp/smb.conf /etc/samba/smb.conf
