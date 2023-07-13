# ArchInstallationGuide

Preparation

## Connect to WLAN (if not LAN)

iwctl --passphrase [password] station wlan0 connect [network]

## Check internet connection

ping -c4 <www.archlinux.org>

## List harddrives

lsblk

## Create partitions

gdisk /dev/sda

## Partition 1: +512M ef00 (for EFI)

## Partition 2: Available space 8300 (for Linux filesystem)

## Write w, Confirm Y

## Sync package

pacman -Syy
Base Installation

## Sync time

timedatectl set-ntp true

## Format partitions (Replace [EFI] and [BOOT] with your partitions shown with lsblk)

mkfs.fat -F 32 /dev/[EFI];
mkfs.btrfs -f /dev/[ROOT]

## Mount points for btrfs

mount /dev/[ROOT] /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt

## btrfs configuration

mount -o compress=zstd:1,noatime,subvol=@ /dev/[BOOT] /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/[BOOT] /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/[BOOT] /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/[BOOT] /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/[BOOT] /mnt/.snapshots
mount /dev/[EFI] /mnt/boot/efi

## Install base packages

pacstrap -K /mnt base base-devel dkms git linux linux-headers linux-firmware vim intel-ucode

## Generate fstab

genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

## Chroot to installed sytem

arch-chroot /mnt

## Configuration

## Set System Time

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

## Update reflector

reflector -c "India" -p https -a 3 --sort rate --save /etc/pacman.d/mirrorlist

## Synchronize mirrors

pacman -Syy

## Install Packages

pacman --noconfirm -S grub xdg-desktop-portal-wlr efibootmgr networkmanager network-manager-applet dialog wpa_supplicant wireless_tools netctl mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call dnsmasq openbsd-netcat ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font exa bat htop ranger zip unzip neofetch duf xorg xorg-server xorg-xinit xclip grub-btrfs xf86-video-amdgpu xf86-video-nouveau xf86-video-intel xf86-video-qxl brightnessctl pacman-contrib

## set lang utf8 US

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

## Set Keyboard (German Keyboard Layout)

## echo "FONT=ter-v18n" >> /etc/vconsole.conf

## echo "KEYMAP=de-latin1" >> /etc/vconsole.conf

## Set Root Password

passwd root

## Add User (Replace [USERNAME] with your name)

useradd -m -g users -G wheel [USERNAME]
passwd [USERNAME]

## Enable Services

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

## Grub installation

## grub-install --target=i386-pc --recheck /dev/vda # for MBR installation

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable # for UEFI
grub-mkconfig -o /boot/grub/grub.cfg

## Add btrfs and setfont to mkinitcpio

## Before: BINARIES=()

## After: BINARIES=(btrfs setfont)

sed -i 's/BINARIES=()/BINARIES=(btrfs setfont)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

## Add user to wheel: uncomment #%wheel ALL=(ALL:ALL) ALL

EDITOR=vim visudo
usermod -aG wheel $username

## Restart

exit
reboot

## Post install step after logging in

## Create Swap file

## switch to root user

su
cd /root/

## count=2048==>2GiB

dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress

## Change permission (r+w)

chmod 600 /swapfile
mkswap /swapfile

## create backup file of fstab

cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
cat /etc/fstab
mount -a

## to check if swap is active

swapon -a

## Set Time-Zone

timedatectl set-timezone Asia/Kolkata

## Synchronize Time

systemctl enable systemd-timesyncd.service

## Set hostname and localhost

echo "vasuki" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 vasuki" >> /etc/hosts

## Install the display server

pacman -S xorg xorg-server mesa

## Setup Desktop Environment

## Gnome

pacman -S gnome gnome-terminal gnome-themes-extra gnome-tweaks

## Enable login screen for gnome

systemctl enable gdm

## KDE

pacman -S plasma-meta kde-applications

## Enable login screen for kde

systemctl enable sddm

## XFCE

pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter

## Enable login screen for xfce

systemctl enable lightdm
