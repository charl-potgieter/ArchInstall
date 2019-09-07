+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				(1) Create machine in VirtualBox
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Validate ISO
-------------

See arch wiki installation guide

In order to verify download:
 - To check SHA-1 of iso in windows can use below cmd function:
	certutil -hashfile C:\Users\Jane\Downloads\archlinux-2019.03.01-x86_64.iso MD5  > tempfile.txt

- Check GnuPG signature using windows version of GnuPG (simple installer for Windows can be downloaded and installed from here if required)
	https://gnupg.org/download/index.html
	Use this command per Arch Wiki in windows command line:
	gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
	(note the iso and signature file need to be saved in same folder.  Above file references is the signature file)


	
Setting up the VirtualBox Machine
--------------------------------
 - Ensure 64 bit arch is selected
 - Set network adaptor to bridged
 - Adjust video memory if required
 - Adjust number of CPUs if required 
 - Stick with BIOS boot.   EFI mode seems more trouble than it is worth

 

Run ArchInstall.sh
-----------------------------
 - Boot live iso and download this script using curl as below
 - curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/ArchInstall.sh > installscript.sh
 - make executable with chmod 755 installscipt.sh
 - run using below to direct stdout and stderr to outfile to review as messages quickly scroll of screen
	./installscript.sh 2>&1 | tee output
- Don't use underscore in hostname - have experienced issues with this




Post Install GUI
-----------------
- Shutdown virtual machine, remove disc and reboot.
 ***** NB above step!!!! **** Forgetting to do this will attempt next install steps on install image!

- curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/PostInstallationGUI.sh > PostInstall.sh

- chmod 755 above file

- run using below to direct stdout and stderr to outfile to review as messages quickly scroll of screen
	./PostInstall.sh 2>&1 | tee postoutput







SSH Keys
-----------------

Do I need to generate ssh keys on server?

Generate ssh keys:
$ ssh-keygen


Add PUBLIC key to my github account via copy and paste (SSH into virtual box if this is a virtual install to enable copy)
Easier to copy from less in virtualbox (if logged in via git bash).   Another option is to copy into a shared folder.


Clone existing github dotfiles into a bare repository
-------------------------------------------------------

Ensure that machine has been restarted and I am now logged in as user not root

Inspiration from below links:
https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
https://news.ycombinator.com/item?id=11070797

Remove any existing dotfiles from $HOME which were automatically created  on system install e.g. .bashrc
(DONT type rm .* as this has potential to delete everything in $HOME)

(No need to create a .gitignore as I have one in the below github repository)

Clone from github into a bare repo (cloning automatically creates a remote called origin)
	git clone --bare git@github.com:charl-potgieter/dotfiles.git $HOME/.dotfiles.git


Checkout	
	git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout
	
Refresh bashrc
	source ~/.bashrc

Can now use git commands with alias e.g. gitdot status etc, gitdot push origin master


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		Sundry
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
If I am having trouble getting fill screen resolution in XFCE worth checking correct resolution under start menu->settings->Display


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		(2) Export machine out of virtualbox (Windows Host) to phyiscal linux machine
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 - See ArchWiki for general guidance
 https://wiki.archlinux.org/index.php/Moving_an_existing_install_into_(or_out_of)_a_virtual_machine

 - Utilise an Arch Linux Install USB (doesn't need to be latest version as machine has already been built in virtualbox)
My previous USB installer(201907) was created on Windows using Rufus as per Arch Wiki below
https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_Windows

 - Create a virtualbox share folder on a USB connected to the Windows host, ideally on the Arch Installer USB above (assuming it is formatted FAT32 and readable by windows.  Mount as below per Arch Wiki Virtualbox page.
mount -t vboxsf -o gid=vboxsf shared_folder_name /mnt

 - Extract the virtualbox machine as a tarball rather than rsync in order to maintain linux file permissions and owners on the windows host.
 
 - Download the folders to exclude from the tarball from this respository 
curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/VirtualTarExclFile > /mnt/ExclFile

 - Split the tarball to ensure that it does not get too big for FAT32 file system
sudo tar --exclude-from=/mnt/ExclFile --xattrs -czpvf - / | split --bytes=500MB - /mnt/export.tar.gz_

 - Ensure the target machine hard drive is prepared (using gparted USB live).  Formatted Ext4 and boot flag set.
 
 - Boot into the new physical machine with the Arch Install Linux USB drive
 
 -  Mount the target hard drive where the new installation will take place eg. mount /dev/sda1 /mnt

- The arch installer usb is mounted at /run/archiso/bootmnt  (to confirm can attempt to mount the usb again and it will most likely give an error message stating it is already mounted at above location).  The Tarballs saved down to the virtualbox shared location will likely be saved in a subfolder of /run/archiso/bootmnt.


 - The tarball can be extracted with someting like below (check tar flags though)
cat /run/archiso/bootmnt/VirtualMachineTarBalls/export.tar.gz_* | tar xvzfp - -C /mnt


 - chroot into the new system using arch-chroot /mnt  (remember this is being run from the arch installer usb)

 - Reinstall GRUB or other bootloader (refer arch wiki for general instructions) 
 grub-install --target=i386-pc /dev/sdX    (NOT sdX1 etc)
 grub-mkconfig -o /boot/grub/grub.cfg
 
  - Adjust fstab  (if using a single partition I don't think there is anything to do here)

 - Re-generate the initramfs image
 mkinitcpio -p linux
 

Need to uninstall virtualbox guest additions and disable daemon?
pacman -Rs virtualbox-guest-utils (or virtualbox-guest-utils-nox for VirtualBox Guest utilities without X support)
systemctl disable vboxservice.service

 - exit chroot, shutdown, remove usb installer and power up new machine.
 
  - When booting there may be a message that start job is running to connect to a network interface e.g enp0s3 which is how the virtual machine connected to network.  Remove this with e.g.:
 sudo systemctl disable dhcpcd@enp0s3.service
 See also 
https://www.linuxbabe.com/virtualbox/a-start-job-is-running-for-sys-subsystem-net-devices-eth0-device





 

