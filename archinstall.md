Arch Linux Installation Using Scripts

#!/bin/bash

echo "Create partitions before proceeding"

echo "Use fdisk or gdisk to create partitions"

`pacman -Syy`

```
timedatectl set-ntp true
```

echo "Format partitions (Replace \[EFI\] and \[BOOT\] with your partitions shown with lsblk)"

```
mkfs.fat -F 32 /dev/sda1
mkfs.btrfs -f /dev/sda2
```

echo "Mount points for btrfs"

```
mount /dev/sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt
```

echo "btrfs configuration"

```
mount -o compress=zstd:1,noatime,subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/sda2 /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/sda2 /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/sda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/sda2 /mnt/.snapshots
mount /dev/sda1 /mnt/boot/efi
```

echo "Install base packages"

`pacstrap -K /mnt base base-devel dkms git linux linux-headers linux-firmware vim reflector intel-ucode`

echo "Generate fstab"

`genfstab -U -p /mnt >> /mnt/etc/fstab`

`cat /mnt/etc/fstab`

echo "Chroot to installed sytem"

`arch-chroot /mnt`

echo "Set System Time"

`ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime`
`hwclock --systohc`

echo "Update mirrorlist"

```
reflector -c "India" -p https -a 3 --sort rate --save /etc/pacman.d/mirrorlist
```

echo "Synchronize mirrors"

```
pacman -Syy
```

echo "Install Packages"

`pacman --noconfirm -S grub xdg-desktop-portal-wlr efibootmgr networkmanager network-manager-applet dialog wpa_supplicant wireless_tools netctl mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync acpi acpi_call dnsmasq ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font exa bat htop ranger zip unzip duf xorg xorg-server xorg-xinit xclip grub-btrfs xf86-video-amdgpu xf86-video-nouveau xf86-video-intel xf86-video-qxl brightnessctl pacman-contrib`

echo "set lang utf8 US"

```
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

echo "Set Root Password"

`passwd root`

echo "Add User (Replace \[USERNAME\] with your name)

useradd -m -g users -G wheel \[USERNAME\]
passwd \[USERNAME\]"

echo "Enable Services"

```
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
```

echo "Grub installation"

#grub-install --target=i386-pc --recheck /dev/vda # for MBR installation

`grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable # for UEFI`

```
grub-mkconfig -o /boot/grub/grub.cfg
```

echo "## Add btrfs and setfont to mkinitcpio

## Before: BINARIES=()

## After: BINARIES=(btrfs setfont)"

```
sed -i 's/BINARIES=()/BINARIES=(btrfs setfont)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux
```

echo "Add user to wheel: uncomment #%wheel ALL=(ALL:ALL) ALL"

`EDITOR=vim visudo`

#Set hostname and localhost

```
echo "vasuki" >> /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     vasuki" >> /etc/hosts
```

`exit`

echo "Arch installed to your system please reboot"

`reboot`
