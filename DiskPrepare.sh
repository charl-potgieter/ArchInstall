# IT WILL DELETE ANY DATA ON DEV/SDA
# Only run this in virtualbox

echo '--------------------------------------------------------------------------------------------'
echo '			Disk partitioning, formatting and mount'
echo '--------------------------------------------------------------------------------------------'

parted /dev/sda mklabel msdos
parted /dev/sda mkpart primary ext4 1MiB 100%
parted /dev/sda set 1 boot on
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
printf '\n\n\n'
