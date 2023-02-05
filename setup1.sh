#!/bin/sh

# Script to install arch on gnome boxes - part 1 :/

# make a new partition table
parted /dev/vda mklabel msdos

# make a new partition
parted /dev/vda mkpart primary ext4 1MiB 100%

# format the partition
mkfs.ext4 /dev/vda1

# mount the partition to /mnt
mount /dev/vda1 /mnt

# install packages
pacstrap -K /mnt base linux linux-firmware networkmanager

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# move setup2.sh to /mnt and execute it
cp setup2.sh /mnt
arch-chroot /mnt chmod +x ./setup2.sh
arch-chroot /mnt ./setup2.sh

# finish
poweroff
