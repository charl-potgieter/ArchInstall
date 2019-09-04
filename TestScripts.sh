#!/bin/bash



echo '--------------------------------------------------------------------------------------------'
echo '			Format and mount hard drive'
echo '--------------------------------------------------------------------------------------------'

printf '\n\n\n'
echo '!!!!!   This will wipe selected hard drive and format  !!!!!!!'
printf '\n'
read -p "Type yes if you want to continue, anything else to cancel: " PROCEED

echo $PROCEED

if [[ $PROCEED == "yes" ]];
then
	echo 'Devices are as follows'
	printf '\n'
	printf '\n'	
	read -p "Enter device to format : " DEVICE
	parted $DEVICE mklabel msdos
	parted $DEVICE mkpart primary ext4 1MiB 100%
	parted $DEVICE set 1 boot on
	mkfs.ext4 $DEVICE
	echo 'Device formatted'
fi
