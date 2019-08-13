High Level Steps
----------------
(1) Create machine in virtualbox

(1.5) Due to FAT32 file size constraints the USB may need to be formated as ExFAT for larger tarballs?  A better option may be to split tarball 
https://unix.stackexchange.com/questions/61774/create-a-tar-archive-split-into-blocks-of-a-maximum-size
Below command seems to work for split
tar --exclude-from=ExclFile --xattrs -czpvf - / | split --bytes=50MB - export.tar_
The tarball can be put back together using below command (SHOULDNT DO THIS AS WILL THEN AGAIN HIT FILE SIZE LIMIT?)
cat export.tar_* > combined.tar



(2) Save tarball of the virtual machine to a USB drive shared by Virtualbox host
(3) Copy tarball onto an existing Arch Linux USB installer disk (doesn't need to be latest verion as this is used for admin only)
(4) Boot new machine using above installer disk and extract tarball onto new machine.
(5) Tweak new machine for setup outside outside of Virtualbox



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


