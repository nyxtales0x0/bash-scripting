#!/bin/sh

# Script to install arch on gnome boxes - part 2 :/

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
yes | pacman -S grub
grub-install /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

# set root password
yes "root" | passwd

# install sudo package
yes | pacman -S sudo

# setup a new user
useradd -m birb
yes "birb" | passwd birb
echo "birb ALL=(ALL:ALL) ALL" >> /etc/sudoers
