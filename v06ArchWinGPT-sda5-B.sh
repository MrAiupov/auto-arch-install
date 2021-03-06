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
pacman -S dialog wpa_supplicant --noconfirm 

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

echo 'Ставим иксы и драйвера'
pacman -S xorg-server xorg-drivers xorg-xinit

echo 'Cтавим SDDM'
pacman -S sddm --noconfirm
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
pacman -S ttf-liberation ttf-dejavu wqy-zenhei --noconfirm 

echo 'Ставим сеть'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo 'Поддержка ntfc формата'
pacman -S ntfs-3g ufw --noconfirm

echo 'Драйвера видеодрайверов Nvidea'
pacman -S nvidia vulkan-tools vulkan-icd-loader lib32-nvidia-utils lib32-vulkan-icd-loader --noconfirm

echo 'Установка аудиодрайверов'
pacman -S alsa-lib alsa-utils lib32-alsa-plugins lib32-curl --noconfirm

echo 'Установить рабочий стол Plasma'

sudo pacman -S plasma-desktop sddm-kcm plasma-pa konsole

echo 'Установка KDE программ'
pacman -S ark spectacle kcalc krita kdenlive powerdevil okular --noconfirm

echo 'Установка Wine'
pacman -S wine wine-gecko wine-mono multilib-devel --noconfirm

echo 'Установка Steam и Litris'
pacman -S steam lib32-alsa-plugins lib32-curl lutris --noconfirm

echo 'Ставим дополнительные программы'
pacman -S screenfetch chromium firefox firefox-i18n-ru opera vlc gimp libreoffice libreoffice-fresh-ru obs-studio audacity qbittorrent dolphin gparted gnome-disk-utility gwenview user-manager kde-gtk-config inkscape handbrake --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo 'Добавление репозитория Herecura'
echo "[herecura]" >> /etc/pacman.conf
echo "Server = https://repo.herecura.be/$repo/$arch" >> /etc/pacman.conf
pacman -Syyy

echo 'Установка AUR Yay'
mkdir -p /tmp/yay_install
cd /tmp/yay_install
sudo pacman -S git  --noconfirm
git clone https://aur.archlinux.org/yay.git --noconfirm
cd yay
makepkg -sir --needed --noconfirm --skippgpcheck
cd ..
cd ..
rm -rf yay_install
cd ..

echo 'Установка завершена! Перезагрузите систему.'
exit
