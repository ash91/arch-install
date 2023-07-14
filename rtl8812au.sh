#!/bin/bash

echo "if connected to internet then clone this repo"

git clone https://github.com/aircrack-ng/rtl8812au.git
cd rtl8812au

#if no internet access
# unzip rtl8812au-5.6.4.2.zip 
#cd rtl8812au-5.6.4.2/

sudo make dkms_install
cd ..
rm -rf rtl8812au

echo "WIFI Driver installed onto your system"

ch