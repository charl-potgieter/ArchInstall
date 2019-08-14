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
 - Create a shared folder called ConfigFiles which contains the relevant configuration files stored on the local machine
 - Create a shared folder called Dropbox
 - Stick with BIOS boot.   EFI mode seems more trouble than it is worth
 

Run ArchInstall.sh
-----------------------------
 - Boot live iso and download this script using curl as below
 - curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/ArchInstall.sh > installscript.sh
 - make executable with chmod 755 installscipt.sh
 - run using below to direct stdout and stderr to outfile to review as messages quickly scroll of screen
	./installscript.sh 2>&1 | tee output
- Don't use underscore in hostname - have experienced issues with this
- Shutdown virtual machine, remove disc and reboot.



Run either PostInstallationServer.sh or PostInstallationServer.sh
---------------------------------------------------------
- curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/PostInstallationServer(or ..GUI).sh > postinstall.sh

- run using below to direct stdout and stderr to outfile to review as messages quickly scroll of screen
	./postinstall.sh 2>&1 | tee postoutput


During post-install of virtualbox package guest utils ensure that virtualbox-host-modules-arch is selected(see Arch Wiki)




SSH Keys
-----------------

Do I need to generate ssh keys on server?

Generate ssh keys:
$ ssh-keygen




Add PUBLIC key to my github account via copy and paste (SSH into virtual box if this is a virtual install to enable copy)
Easier to copy from less in virtualbox (if logged in via git bash)


Clone existing github dotfiles into a bare repository
-------------------------------------------------------

Inspiration from below links:
https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
https://news.ycombinator.com/item?id=11070797

Remove any existing dotfiles from $HOME which were automatically created  on system install e.g. .bashrc

(No need to create a .gitignore as I have one in the below github repository)

Clone from github into a bare repo (cloning automatically creates a remote called origin)
	git clone --bare git@github.com:charl-potgieter/dotfiles.git $HOME/.dotfiles.git


Checkout	
	git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout
	
Refresh bashrc
	source ~/.bashrc

Can now use git commands with alias e.g. gitdot status etc, gitdot push origin master



+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		(2) Export machine out of virtualbox (Windows Host) to phyiscal linux machine
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


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


The tarball can be extracted with someting like below (check tar flags though)
cat /run/archiso/bootmnt/VirtualMachineTarBalls/export.tar.gz_* | tar xvzfp - -C /mnt/temp/TestExtract/

(5) Tweak new machine for setup outside outside of Virtualbox


