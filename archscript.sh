#!/bin/bash
setfont ter-132b

echo "Create partitions before proceeding"

echo "Use fdisk or gdisk to create partitions"

pacman -Syy

timedatectl set-ntp true

echo "Format partitions (Replace [EFI] and [BOOT] with your partitions shown with lsblk)"

mkfs.fat -F 32 /dev/sda1
mkfs.btrfs -f /dev/sda2

echo "Mount points for btrfs"

mount /dev/sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt

echo "btrfs configuration"

mount -o compress=zstd:1,noatime,subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/sda2 /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/sda2 /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/sda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/sda2 /mnt/.snapshots
mount /dev/sda1 /mnt/boot/efi