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

# chroot into /mnt --- DON'T DO IT WTF
# arch-chroot /mnt

# setup locale
arch-chroot /mnt echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# setup host name
arch-chroot /mnt echo "arch-vm" >> /etc/hostname

# pacman configuration
arch-chroot /mnt sed -i "s/# Misc options/# Misc options\nColor/" /etc/pacman.conf
arch-chroot /mnt sed -i "s/# Misc options/# Misc options\nParallelDownloads = 5/" /etc/pacman.conf

# install and setup grub
arch-chroot /mnt yes | pacman -S grub
arch-chroot /mnt grub-install /dev/vda
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# set root password
arch-chroot /mnt yes "root" | passwd

# install sudo package
arch-chroot /mnt yes | pacman -S sudo

# setup a new user
arch-chroot /mnt useradd -m birb
arch-chroot /mnt yes "birb" | passwd birb
arch-chroot /mnt echo "birb ALL=(ALL:ALL) ALL" >> /etc/sudoers

# finish setup
reboot
