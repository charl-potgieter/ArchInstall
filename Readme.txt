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
 - Stick with BIOS boot.   EFI mode seems more trouble than it is worth
 

Run ArchInstall.sh
-----------------------------
 - Boot live iso and download this script using curl as below
 - curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/ArchInstall.sh > installscript.sh
 - make executable with chmod 755 installscipt.sh
 - run using below to direct stdout and stderr to outfile to review as messages quickly scroll of screen
	./installscript.sh 2>&1 | tee output
- Don't use underscore in hostname - have experienced issues with this
 



Install openssh
-----------------


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


