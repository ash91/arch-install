#!/bin/bash

#Update the system
sudo pacman -Syu --noconfirm

#Installing the required packages
echo "Installing packages"
sudo pacman -S - < pkglist.txt

# Installing AUR packages
echo "Installing AUR packages"

for p in $(< aur-pkg.txt); do yay -S --needed $p --noconfirm; done

# Add user to docker group
sudo usermod -aG docker $USER

# For ansible to work
export LANG=en_IN.UTF-8

# Enable system services 
sudo systemctl enable --now fstrim.timer
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now docker.socket

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

#Installing starship

curl -sS https://starship.rs/install.sh | sh

cp starship.toml ~/.config/

echo eval "$(starship init bash)" >> ~/.bashrc

#Download plank themes
mkdir -p ~/.local/share/plank/themes/
mv plank-themes/* ~/.local/share/plank/themes/

echo "neofetch | lolcat" >> ~/.bashrc

#Themeing- WhiteSur
#git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1

#cd WhiteSur-gtk-theme

#./install.sh -c Dark -i manjaro 

#cd ..

#rm -rf WhiteSur-gtk-theme


#WhiteSur Icons
#git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git

#cd WhiteSur-icon-theme

#sudo ./install.sh 

#cd ..

#rm -rf WhiteSur-icon-theme

#WhiteSur Cursors
#git clone https://github.com/vinceliuice/WhiteSur-cursors.git

#cd WhiteSur-cursors

#sudo ./install.sh

#cd ..

#rm -rf WhiteSur-cursors

#Kora Icons

#git clone https://github.com/bikass/kora.git

#cd kora

#sudo mv kora /usr/share/icons

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

