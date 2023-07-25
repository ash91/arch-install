#!/bin/bash

#echo "Installing Wi-FI Driver"

#./rtl8812au.sh

#echo "Installing yay(AUR Helper)"

#git clone https://aur.archlinux.org/yay.git
#cd yay
#makepkg -si
#cd ..

#Update the system
sudo pacman -Syu --noconfirm

#Installing the required packages
echo "Installing packages"
sudo pacman -S - < package.txt --noconfirm

# Installing AUR packages
echo "Installing AUR packages"

for p in $(< aur-pkg.txt); do yay -S --needed $p --noconfirm; done

# Add user to docker group
sudo usermod -aG docker $USER

# Enable system services 
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now docker.socket
#sudo systemctl enable --now lightdm

#Start Default Network for Networking

#VIRSH is a command to directly interact with our VMs from terminal. We use it to list networks, vm-status and various other tools when we need to make tweaks. Here is how we start the default and make it auto-start after reboot.

sudo virsh net-start default

echo "Network default started"

sudo virsh net-autostart default

echo "Network default marked as autostarted"

#Check status with:

sudo virsh net-list --all

# Add User to libvirt to Allow Access to VMs

sudo usermod -aG libvirt $USER
sudo usermod -aG libvirt-qemu $USER
sudo usermod -aG kvm $USER
sudo usermod -aG input $USER
sudo usermod -aG disk $USER

# Install GRUB themes
git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes
cd Top-5-Bootloader-Themes
sudo ./install.sh
cd ..
rm -rf Top-5-Bootloader-Themes
#Installing starship

curl -sS https://starship.rs/install.sh | sh

cp starship.toml ~/.config/

echo eval "$(starship init bash)" >> ~/.bashrc

echo "neofetch | lolcat" >> ~/.bashrc

./themes.sh

./zram.sh

echo "Updates done to your system please reboot"

read -p "Enter (y/n)? " answer
case ${answer:0:1} in
    y|Y )
	echo "Rebooting Now"
	sleep 3
	reboot
    ;;
    * )
        echo exit
    ;;
esac

