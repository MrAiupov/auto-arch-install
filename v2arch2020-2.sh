#!/bin/bash

read -p "Введите имя компьютера: " hostname
read -p "Введите имя пользователя: " username

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime

echo '3.4 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
localectl set-x11-keymap us,ru pc104 "" grp:alt_shift_toggle

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

echo 'Устанавливаем xorg и его драйвера'
pacman -S xorg-server xorg-drivers xorg-xinit --noconfirm 

echo 'Устанавливаем часто используемый шрифт, плюс поддержку иероглифоф'
pacman -S ttf-liberation ttf-dejavu wqy-zenhei --noconfirm 

echo 'Устанавливаем поддержку сети'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo 'Устанавливаем поддержку ntfs разделов'
pacman -S ntfs-3g ufw --noconfirm

echo 'Установка аудиодрайверов'
pacman -S alsa-lib alsa-utils lib32-alsa-plugins lib32-curl --noconfirm

echo 'Включаем автоподключение интернета'
systemctl enable NetworkManager

echo 'Установка завершена! Перезагрузите систему.'
exit
