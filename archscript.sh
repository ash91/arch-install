#!/bin/bash

echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "by Ashish Deshpande"
echo "-----------------------------------------------------"
echo ""
echo "Warning: Run this script at your own risk."
echo ""


echo "Create partitions before proceeding"

echo "Use fdisk or gdisk to create partitions"

pacman -Syy

timedatectl set-ntp true

echo "Format partitions (Replace [EFI] and [BOOT] with your partitions shown with lsblk)"

fdisk /dev/vda

mkfs.fat -F 32 /dev/vda1
mkfs.btrfs -f /dev/vda2

echo "Mount points for btrfs"

mount /dev/vda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt

echo "btrfs configuration"

mount -o compress=zstd:1,noatime,subvol=@ /dev/vda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/vda2 /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/vda2 /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/vda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/vda2 /mnt/.snapshots
mount /dev/vda1 /mnt/boot/efi

echo "Install base packages"

pacstrap -K /mnt - < base.txt

echo "Generate fstab"

genfstab -U -p /mnt >> /mnt/etc/fstab

cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# 

mkdir /mnt/archinstall
cp config.sh /mnt/archinstall
cp install.sh /mnt/archinstall
cp themes.sh /mnt/archinstall
cp zram.sh /mnt/archinstall

echo "Chroot to installed sytem"

arch-chroot /mnt ./archinstall/config.sh