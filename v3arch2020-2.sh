#!/bin/bash

read -p "Введите имя компьютера: " hostname
read -p "Введите имя пользователя: " username

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime

echo '3.4 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Создадим загрузочный RAM диск'
mkinitcpio -p linux

echo '3.5 Устанавливаем загрузчик'
pacman -Syy
pacman -S grub --noconfirm 
grub-install /dev/sda

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -S dialog whois dhclient ethtool openconnect openvpn rp-pppoe wireless-regdb wireless_tools wpa_supplicant wvdial gnu-netcat iwd --noconfirm 

echo 'Ставим сеть'
pacman -S b43-fwcutter broadcom-wl-dkms r8168 dnsutils ipw2100-fw ipw2200-fw modemmanager netctl net-tools networkmanager networkmanager-openvpn network-manager-applet ppp nss-mdns usb_modeswitch --noconfirm

echo 'Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username

echo 'Создаем root пароль'
passwd

echo 'Устанавливаем пароль пользователя'
passwd $username

echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo "Куда устанавливем Arch Linux на виртуальную машину?"
read -p "1 - Да, 0 - Нет: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit xorg-xkill xorg-xrandr xorg-xinput"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit xorg-xkill xorg-xrandr xorg-xinput virtualbox-guest-utils"
fi

echo 'Ставим иксы и драйвера'
pacman -S $gui_install

echo 'Установка KDE Plasma'
pacman -Sy plasma kdebase packagekit-qt5 kdeconnect fwupd python-dbus kdebase-meta qwenview ark okular --noconfirm

echo 'Cтавим SDDM'
pacman -S sddm sddm-kcm --noconfirm
systemctl enable sddm

echo "[General]" > /etc/sddm.conf
echo "# Halt command" >> /etc/sddm.conf
echo "HaltCommand=/bin/systemctl poweroff" >> /etc/sddm.conf
echo "# Initial NumLock state" >> /etc/sddm.conf
echo "# Valid values: on|off|none" >> /etc/sddm.conf
echo "# If property is set to none, numlock won't be changed Numlock=on" >> /etc/sddm.conf
echo "Numlock=on" >> /etc/sddm.conf
echo "# Reboot command" >> /etc/sddm.conf
echo "RebootCommand=/bin/systemctl reboot" >> /etc/sddm.conf

echo 'Ставим шрифты'
pacman -S ttf-dejavu gnu-free-fonts ttf-liberation ttf-bitstream-vera ttf-ubuntu-font-family cantarell-fonts noto-fonts noto-fonts-cjk ttf-croscore ttf-carlito ttf-caladea wqy-zenhei freetype2 --noconfirm 

echo 'Поддержка ntfc формата'
pacman -S ntfs-3g ufw --noconfirm

echo 'Драйвера видеодрайверов Nvidea'
pacman -S nvidia nvidia-settings vulkan-tools vulkan-icd-loader lib32-nvidia-utils lib32-vulkan-icd-loader --noconfirm

echo 'Установка аудиодрайверов'
pacman -S alsa-lib alsa-utils alsa-plugins alsa-firmware plasma-pa pulseaudio pavucontrol paprefs --noconfirm

echo 'Системные программы и драйвера'
pacman -S efibootmgr dosfstools mtools openssh intel-ucode amd-ucode os-prober grub-tools wget bash-completion lsb-release pcurses s-tui tlp yad reflector xdg-utils xdg-user-dirs gvfs gvfs-mtp gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-nfs gvfs-smb accountsservice smartmontools libwnck3 linux-atm ndisc6 pptpclient vpnc xl2tpd dnsmasq upower hwinfo gtop python solid mlocate ffmpegthumbnailer poppler-glib libgsf libopenraw gst-libav gst-plugins-bad gst-plugins-ugly --noconfirm

echo 'Установка KDE программ'
pacman -S ark spectacle kcalc krita kdenlive powerdevil okular --noconfirm

echo 'Установка Wine'
pacman -S wine wine-gecko wine-mono multilib-devel --noconfirm

echo 'Установка Steam и Litris'
pacman -S steam lib32-alsa-plugins lib32-curl lutris --noconfirm

echo 'Ставим дополнительные программы'
pacman -S screenfetch neofetch chromium firefox firefox-i18n-ru opera vlc gimp libreoffice libreoffice-fresh-ru obs-studio audacity qbittorrent hardinfo glances htop libdvdcss --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo 'Установка завершена! Перезагрузите систему.'
exit
