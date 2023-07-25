#!/bin/bash

#   ____             __ _                       _   _             
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#       

echo "Set System Time"

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

echo "Update mirrorlist"

# reflector -c "India" -p https -a 3 --sort rate --save /etc/pacman.d/mirrorlist

echo "Synchronize mirrors"

pacman -Syy

echo "set lang utf8 US"

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "Set hostname and localhost"

echo "vasuki" >> /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     vasuki" >> /etc/hosts

echo "Set Root Password"

passwd root


echo "Add User (Replace [USERNAME] with your name)

useradd -m -G wheel [USERNAME]
passwd [USERNAME]"

user=""
echo -n "Enter username: "
read username
useradd -m -G wheel $username
passwd $username

echo "Enable Services"

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid
systemctl enable systemd-timesyncd.service

echo "Grub installation"

grub-install --target=i386-pc --recheck /dev/vda # for MBR installation

# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable # for UEFI

grub-mkconfig -o /boot/grub/grub.cfg


echo "## Add btrfs and setfont to mkinitcpio

## Before: BINARIES=()

## After: BINARIES=(btrfs setfont)"

sed -i 's/BINARIES=()/BINARIES=(btrfs setfont)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
clear
echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=vim sudo -E visudo
usermod -aG wheel $username

pacman -Rsu iptables-nft

# ------------------------------------------------------
# Copy installation scripts to home directory 
# -


cp /archinstall/install.sh /home/$username/Downloads/
cp /archinstall/themes.sh /home/$username/Downloads/
cp /archinstall/zram.sh /home/$username/Downloads/

clear

echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo ""


echo "exit from chroot and then reboot"
