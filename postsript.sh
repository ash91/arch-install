echo "## Post install step after logging in"

echo "#Set Time-Zone"

sudo timedatectl set-timezone Asia/Kolkata

echo "#Synchronize Time"

sudo systemctl enable systemd-timesyncd.service

# echo "#Set hostname and localhost"

# sudo echo "vasuki" >> /etc/hostname
# sudo echo "127.0.0.1 localhost" >> /etc/hosts
# sudo echo "::1 localhost" >> /etc/hosts
# sudo echo "127.0.1.1 vasuki" >> /etc/hosts

echo " Install the display server"

sudo pacman -S xorg xorg-server mesa

echo "#Setup Desktop Environment"

#Gnome

sudo pacman -S gnome gnome-terminal gnome-themes-extra gnome-tweaks gtk-engine-murrine


echo "## Enable login screen for gnome"

sudo systemctl enable gdm

#KDE

#pacman -S plasma-meta kde-applications

#Enable login screen for kde

#systemctl enable sddm

#XFCE

#pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter

#Enable login screen for xfce

#systemctl enable lightdm

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