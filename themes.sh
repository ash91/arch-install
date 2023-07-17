#!/bin/bash

#Download plank themes
mkdir -p ~/.local/share/plank/themes/
cp -r plank-themes/* ~/.local/share/plank/themes/

#Install ulauncher themes

cp -r ./user-themes/ ~/.config/ulauncher/

echo "Installing rose-pine theme & icons"

#Install Rose-Pine-GTK-Theme

# Cloning the repo

git clone https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git

mkdir ~/.themes
mkdir ~/.icons
mkdir ~/.color-schemes

cd Rose-Pine-GTK-Theme

mv themes/* ~/.themes/

mv icons/* ~/.icons/

mv extra/text-editor/* ~/.color-schemes

cd ..

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
