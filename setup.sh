#!/bin/sh

# Script to install arch on gnome boxes lol

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

# chroot into /mnt
arch-chroot /mnt

# setup locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# setup host name
echo "arch-vm" >> /etc/hostname

# pacman configuration
sed -i "s/# Misc options/# Misc options\nColor/" /etc/pacman.conf
sed -i "s/# Misc options/# Misc options\nParallelDownloads = 5/" /etc/pacman.conf

# install and setup grub
pacman -S grub
grub-install /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

# set root password
yes "root" | passwd

# install sudo package
pacman -S sudo

# setup a new user
useradd -m birb
yes "birb" | passwd birb
echo "birb ALL=(ALL:ALL) ALL" >> /etc/sudoers

# finish setup
exit
reboot
