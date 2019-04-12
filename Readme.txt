Validate ISO
------------

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
 
	
	
General
-------

 - Booting in EFI mode seems more trouble than it is worth for the moment - stick with BIOS
 - Don't use underscore in hostname - have experienced issues with this
 



Static IP address
-----------------
 - If performing a virtualbox install ensure that Network adaptor is set to Bridged (need a virtual machine restart after doing this)
 - All I have done to date is below (where ip address and enp0s3 are obtained from ip address show):
	ip address add 192.168.0.4 broadcast + dev enp0s3

NEED TO EXPAND HERE:  I COMPELTED THIS LATER:
ip route add PREFIX via address dev interface (where prefix is gateway = 192.168.0.1)
therefore:
ip link set enp0s3 up
ip route add 192.168.0.1 via 192.168.0.4 dev enp0s3
	

Configure basic usage for systemd-networkd
https://wiki.archlinux.org/index.php/Systemd-networkd#Wired_adapter_using_a_static_IP
	
	
Need to try:
https://wiki.archlinux.org/index.php/Systemd-resolved
Where is /run/systemd/resolve/stub-resolv.conf?

	
Disk partitioning and formatting
--------------------------------
Rather use  parted than fdisk (I am more familiar with parted)

run parted with say parted /dev/sdX:
(parted) mklabel msdos
(parted) mkpart primary ext4 1MiB 100%
(parted) set 1 boot on

Format partition
mkfs.ext4 /dev/sdX1


Bootloader
----------
Use GRUB
	pacman -S grub
	grub-install --target=i386-pc /dev/sdX   (NOT .../sdXi)
	grub-mkconfig -o /boot/grub/grub.cfg

	
	

Other Installation steps
------------------------
	
???? Is there a need to install dhcpd?  Setup static IP address using dhcp especially for server

Install vim:
sudo pacman -S vim



Notes for virtual machines
--------------------------
Set network adaptor to "Bridged" to allow SSH access



Hostname
--------
See Arch Wiki network configuration.   May need to install samba and enable nmb.service to be able to ping / ssh based on hostname
https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname


Install openssh
-----------------

sudo pacman -S openssh

Generate ssh keys:
$ ssh-keygen

Set up SSH server (just easier especially in virtualbox to SSH into the machine rather, that way I can copy and paste):
 - enable and start sshd.service (initially allowing password access)
 - copy key across from client using ssh-copy-id username@<remote-server.org or ip address>
  - Set "PasswordAuthentication no" in /etc/ssh/sshd_config 
  


Install and configure git
-------------------------

Install git

Configure git:
$ git config --global user.name  "Charl Potgieter"
$ git config --global user.email "charl.j.potgieter@gmail.com"
 

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
	git clone --bare git@github.com:charl-potgieter/test_dotfiles.git $HOME/.dotfiles.git


Checkout	
	git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout
	
Refresh bashrc
	source ~/.bashrc

Can now use git commands with alias e.g. gitdot status etc, gitdot push origin master


