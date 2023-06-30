#!/bin/bash

#Update the system
sudo pacman -Syu --noconfirm

#Installing the required packages

sudo pacman -S - < pkglist.txt

# Installing AUR packages
echo "Installing AUR packages"

for p in $(< aur-pkg.txt); do yay -S --needed $p --noconfirm; done

# Add user to docker group
sudo usermod -aG docker $USER

# For ansible to work
export LANG=en_IN.UTF-8

# Enable services for docker & prometheus
sudo systemctl enable --now docker
sudo systemctl enable --now prometheus.service

#Installing starship

curl -sS https://starship.rs/install.sh | sh

cp starship.toml ~/.config/

echo eval "$(starship init bash)" >> ~/.bashrc

#Download plank themes

git clone https://github.com/arcolinux/arcolinux-plank-themes.git

mv arcolinux-plank-themes/usr/share/plank/themes/* ~/.local/share/plank/themes/

#Themeing- WhiteSur
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1

cd WhiteSur-gtk-theme

./install.sh -c Dark -i manjaro 

cd ..

rm -rf WhiteSur-gtk-theme


#WhiteSur Icons
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git

cd WhiteSur-icon-theme

sudo ./install.sh 

cd ..

rm -rf WhiteSur-icon-theme

#WhiteSur Cursors
git clone https://github.com/vinceliuice/WhiteSur-cursors.git

cd WhiteSur-cursors

sudo ./install.sh

cd ..

rm -rf WhiteSur-cursors

#Kora Icons

git clone https://github.com/bikass/kora.git

cd kora

sudo mv kora /usr/share/icons

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

