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
    1) yay -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter --noconfirm; sudo systemctl enable --now lightdm;;
    2) yay -S gnome gnome-extra gnome-themes-extra gnome-tweaks gtk-engine-murrine --noconfirm; sudo systemctl enable --now gdm;;
    3) yay -S plasma --noconfirm; sudo systemctl enable --now sddm;;
    4) yay -S cinnamon lightdm lightdm-gtk-greeter --noconfirm; sudo systemctl enable --now lightdm;;
    5) yay -S qtile && sudo systemctl enable --now lightdm;;
    *) echo "Please enter valid choice."
esac
#Download plank themes
mkdir -p ~/.local/share/plank/themes/
cp -r plank-themes/* ~/.local/share/plank/themes/

# echo "Installing theme & icons"

#Install Rose-Pine-GTK-Theme

# Cloning the repo

# git clone https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git

mkdir ~/.themes
mkdir ~/.icons

# cd Rose-Pine-GTK-Theme

# mv themes/* ~/.themes/

# mv icons/* ~/.icons/

# cd ..

#installing the vimix cursors

git clone https://github.com/vinceliuice/Vimix-cursors.git

cd Vimix-cursors

sudo ./install.sh

cd ..

sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.icons
flatpak override --user --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-4.0

#Applying default gnome theme & icons

# gsettings set org.gnome.desktop.interface gtk-theme 'RosePine-Main-B'
# gsettings set org.gnome.desktop.wm.preferences theme 'RosePine-Main-B'
# gsettings set org.gnome.desktop.wm.preferences theme "RosePine-Main-B"
# gsettings set org.gnome.desktop.interface icon-theme 'Rose-Pine-Moon'

xfconf-query -c xsettings -p /Net/ThemeName -s "RosePine-Main-B"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Rose-Pine-Moon"

rm -rf Vimix-cursors

rm -rf Rose-Pine-GTK-Theme
