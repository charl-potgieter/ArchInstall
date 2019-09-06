#!/bin/bash


echo '--------------------------------------------------------------------------------------------'
echo '			Install virtualbox guest additions'
echo '--------------------------------------------------------------------------------------------'

read -p "Enter (1) for virtualbox-guest-utils-nox, (2) for virtualbox-guest-utils : " VBOX

if [[ "$VBOX" == 1 ]]; then
	echo "One"
else
	echo "something else"
fi


printf '\n\n\n'

