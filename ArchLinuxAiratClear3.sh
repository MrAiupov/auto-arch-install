#!/bin/bash

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

echo 'Драйвера видеодрайверов Nvidea'
pacman -S nvidia vulkan-tools vulkan-icd-loader lib32-nvidia-utils lib32-vulkan-icd-loader --noconfirm

echo 'Установка аудиодрайверов'
pacman -S alsa-lib alsa-utils lib32-alsa-plugins lib32-curl --noconfirm

echo 'Установить рабочий стол Plasma'
sudo pacman -S plasma-desktop plasma-pa konsole powerdevil kscreen khotkeys --noconfirm

echo 'Установка нужных программ'
pacman -S dolphin ark kate spectacle kcalc okular gnome-disk-utility gparted gwenview kde-gtk-config user-manager screenfetch chromium --noconfirm

echo 'Установка Wine'
pacman -S wine wine-gecko wine-mono multilib-devel --noconfirm

echo 'Установка Steam и Litris'
pacman -S steam lutris --noconfirm

echo 'Ставим дополнительные программы'
pacman -S firefox firefox-i18n-ru opera opera-ffmpeg-codecs vlc elisa gimp krita kdenlive libreoffice libreoffice-fresh-ru obs-studio audacity qbittorrent inkscape handbrake --noconfirm

echo 'Установка завершена! Перезагрузите систему.'
exit
