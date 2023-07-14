echo "## Post install step after logging in"

echo "## Create Swap file"

echo "## switch to root user"

su
cd /root/

#count=2048==>2GiB

dd if=/dev/zero of=/swapfile bs=1M count=3072 status=progress

echo "#Change permission (r+w)"

chmod 600 /swapfile
mkswap /swapfile

#create backup file of fstab

cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
cat /etc/fstab
mount -a

#to check if swap is active

swapon -a

echo "#Set Time-Zone"

timedatectl set-timezone Asia/Kolkata

echo "#Synchronize Time"

systemctl enable systemd-timesyncd.service

echo "#Set hostname and localhost"

echo "vasuki" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 vasuki" >> /etc/hosts

echo " Install the display server"

pacman -S xorg xorg-server mesa

echo "#Setup Desktop Environment"

#Gnome

pacman -S gnome gnome-terminal gnome-themes-extra gnome-tweaks gtk-engine-murrine


echo "## Enable login screen for gnome"

systemctl enable gdm

#KDE

#pacman -S plasma-meta kde-applications

#Enable login screen for kde

#systemctl enable sddm

#XFCE

#pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter

#Enable login screen for xfce

#systemctl enable lightdm

echo "Installing Wi-Fi Driver"

./rtl8812au.sh

echo "Installing user-defined packages"

./install.sh

echo "Installed display manager to your system please reboot"

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