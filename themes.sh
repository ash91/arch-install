#!/bin/bash

echo "Selete Desktop Environment to Install"
echo "1 - XFCE"
echo "2 - GNOME"
echo "3 - KDE"
echo "4 - Cinnamon"
echo "5 - Qtile"

echo -n "Enter Desktop Environment of your choice: "

read distro;

case $distro in
    1) yay -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter --noconfirm; sudo systemctl enable lightdm;;
    2) yay -S gnome gnome-extra gnome-themes-extra gnome-tweaks gtk-engine-murrine --noconfirm; sudo systemctl enable gdm;;
    3) yay -S plasma --noconfirm; sudo systemctl enable sddm;;
    4) yay -S cinnamon lightdm lightdm-gtk-greeter --noconfirm; sudo systemctl enable lightdm;;
    5) yay -S qtile && sudo systemctl enable lightdm;;
    *) echo "Please enter valid choice."
esac
#Download plank themes
mkdir -p ~/.local/share/plank/themes/
cp -r plank-themes/* ~/.local/share/plank/themes/

echo "::)) Installing theme & icons ((::"

echo "Installing 🧛🏻‍♂️ Dracula 🧛🏻‍♂️ Theme ::"

mkdir ~/.themes
mkdir ~/.icons
mkdir -p ~/.local/share/kvantum/

git clone https://github.com/dracula/gtk.git

cd gtk

cp -r ./* ~/.themes
cp -r ./kde/cursors/Dracula-cursors ~/.icons
cp -r ./kde/kvantum/* ~/.local/share/kvantum/
cd ..
rm -rf gtk

git clone https://github.com/m4thewz/dracula-icons.git
cd dracula-icons
cp -r * ~/.icons
cd..
rm -rf dracula-icons

#installing the vimix cursors

# git clone https://github.com/vinceliuice/Vimix-cursors.git

# cd Vimix-cursors

# sudo ./install.sh

# cd ..

sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.icons
flatpak override --user --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-4.0


# gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
# gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
# gsettings set org.gnome.desktop.interface icon-theme "Dracula"

xfconf-query -c xsettings -p /Net/ThemeName -s "Dracula"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Dracula"

#rm -rf Vimix-cursors

