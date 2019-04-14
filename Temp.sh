#!/bin/bash


echo '--------------------------------------------------------------------------------------------'
echo '        Select the  root password'
echo '--------------------------------------------------------------------------------------------'
printf '\n'
passwd


echo '--------------------------------------------------------------------------------------------'
echo '        Allow editing of sudo file'
echo '--------------------------------------------------------------------------------------------'

printf '\n'
echo 'editing with visudo.   Uncomment  %wheel    ALL=(ALL) ALL'
read -p "Press enter to continue... "
visudo


echo '--------------------------------------------------------------------------------------------'
echo '        Add user charl (with home directory) and set password and add to wheel group'
echo '--------------------------------------------------------------------------------------------'

useradd -m charl
passwd charl
gpasswd -a charl wheel
