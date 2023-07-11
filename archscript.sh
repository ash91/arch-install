#!/bin/bash
setfont ter-132b
echo "Connect to WLAN (if not LAN)
iwctl --passphrase [password] station wlan0 connect [network]"
timedatectl set-ntp true
echo "Partition the disks using fdisk or gdisk"
