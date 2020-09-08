#!/bin/bash

# Arch Linux Fast Install - Быстрая установка Arch Linux https://github.com/ordanax/arch2018
# Цель скрипта - быстрое развертывание системы с вашими персональными настройками (конфиг, темы, программы и т.д.).

loadkeys ru
setfont cyr-sun16

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo '2.4.2 Форматирование дисков'
mkfs.ext4 /dev/sda7

echo '2.4.3 Монтирование дисков'
mount /dev/sda7 /mnt
mkfs.ext4 /dev/sda6
mkdir /mnt/home
mount /dev/sda6 /mnt/home
mkswap /dev/sda5
swapon /dev/sda5
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir /mnt/media
mkdir /mnt/media/data
mkdir /mnt/media/system
mount /dev/sdb1 /mnt/media/data
mount /dev/sdb2 /mnt/media/system

echo '3.1 Выбор зеркал для загрузки. Ставим зеркала для России'
echo "##" > /etc/pacman.d/mirrorlist
echo "##Arch Linux repository mirrorlist" >> /etc/pacman.d/mirrorlist
echo "##Generated on 2020-02-19" >> /etc/pacman.d/mirrorlist
echo "##" >> /etc/pacman.d/mirrorlist
echo "##Russia" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = https://mirror.yandex.ru/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.truenetwork.ru/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.rol.ru/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = https://mirror.rol.ru/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://archlinux.zepto.cloud/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/JU3hZ)"
