# TO DO
# - add exec startxfce4 to Xinitrc  see arch wiki xfce (need to do this in dotfiles)
# - auto start X at login (see arch wiki xinit) (need to do this in dotfiles)



# RUN AS SUDO




echo '--------------------------------------------------------------------------------------------'
echo '			Systems upgrade'
echo '--------------------------------------------------------------------------------------------'

pacman -Syu
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Get and install server program list'
echo '--------------------------------------------------------------------------------------------'

curl -L https://raw.githubusercontent.com/charl-potgieter/ArchInstall/master/pkg.list.gui > /pkg.list.temp
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
echo '			Create new user and add to wheel'
echo '--------------------------------------------------------------------------------------------'

read -p "Enter user name (to be added to wheel group and home dir created) : " MYUSERNAME
useradd -m $MYUSERNAME
gpasswd -a $MYUSERNAME wheel
printf '\n\n\n'

echo '--------------------------------------------------------------------------------------------'
echo '			Set user password'
echo '--------------------------------------------------------------------------------------------'

passwd $MYUSERNAME
printf '\n\n\n'


echo '--------------------------------------------------------------------------------------------'
echo '			Remove existing dot files'
echo '--------------------------------------------------------------------------------------------'

rm -r $HOME/.*
rm $HOME/.*



echo '--------------------------------------------------------------------------------------------'
echo '			Setup git'
echo '--------------------------------------------------------------------------------------------'

read -p "Enter git name : " GITNAME
read -p "Enter git email address : " GITEMAIL

git config --global user.name  "$GITNAME"
git config --global user.email "$GITEMAIL"

printf '\n\n\n'
