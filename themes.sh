#!/bin/bash
#
#Install Tokyo-Night-GTK-Theme
#
# Cloning the repo

git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git

mkdir ~/.themes
mkdir ~/.icons

cd Tokyo-Night-GTK-Theme

mv themes/* ~/.themes/

mv icons/* ~/.icons/

#installing the vimix cursors

git clone https://github.com/vinceliuice/Vimix-cursors.git

cd Vimix-cursors

./install.sh

cd ..

rm -rf Vimix-cursors
