#!/bin/bash

sudo pacman -S make dkms paru --noconfirm 

#if connected to internet then clone this repo
#git clone https://github.com/aircrack-ng/rtl8812au.git
#cd rtl8812au

#if no internet access
unzip rtl8812au-5.6.4.2.zip 
cd rtl8812au-5.6.4.2/

sudo make dkms_install
cd ..
rm -rf rtl8812au-5.6.4.2

echo "WIFI Driver installed onto your system please reboot"

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


