#!/bin/bash


echo '--------------------------------------------------------------------------------------------'
echo '			Install virtualbox guest additions'
echo '--------------------------------------------------------------------------------------------'

read -p "Enter (1) for virtualbox-guest-utils-nox, (2) for virtualbox-guest-utils : " VBOX

if [[ $VBOX -eq 1 ]]; then
	echo "1"
else
	echo "2"
fi


printf '\n\n\n'

