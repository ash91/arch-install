#!/bin/bash

sudo pacman -S make dkms paru --noconfirm 
git clone https://github.com/aircrack-ng/rtl8812au.git

cd rtl8812au
sudo make dkms_install
sleep 7
reboot
