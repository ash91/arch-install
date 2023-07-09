#!/bin/bash
#
#Install Tokyo-Night-GTK-Theme
#
# Cloning the repo

git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git

mkdir ~/.themes
mkdir ~/.icons
mkdir ~/.color-schemes

cd Tokyo-Night-GTK-Theme

mv themes/* ~/.themes/

mv icons/* ~/.icons/

mv extra/text-editor/* ~/.color-schemes

cd ..

#installing the vimix cursors

git clone https://github.com/vinceliuice/Vimix-cursors.git

cd Vimix-cursors

sudo ./install.sh

cd ..

xfconf-query -c xsettings -p /Net/ThemeName -s "Tokyonight-Dark-B"
xfconf-query -c xsettings -p /Net/IconThemeName -s "oomox-Tokyonight-Dark"

rm -rf Vimix-cursors

rm -rf Tokyo-Night-GTK-Theme
