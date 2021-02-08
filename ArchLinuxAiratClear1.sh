#!/bin/bash

# Arch Linux Fast Install - Быстрая установка Arch Linux https://github.com/ordanax/arch2018
# Цель скрипта - быстрое развертывание системы с вашими персональными настройками (конфиг, темы, программы и т.д.).

loadkeys ru
setfont cyr-sun16

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo '2.4.2 Форматирование и монтирование дисков'
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p3
mount /dev/nvme0n1p3 /mnt
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
mkdir /mnt/work
mkdir /mnt/movie
mkdir /mnt/archive
mkdir /mnt/files
mount /dev/sdb2 /mnt/work
mount /dev/sdb3 /mnt/movie
mount /dev/sdb4 /mnt/archive
mount /dev/sda1 /mnt/files

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

arch-chroot /mnt sh -c "$(curl -fsSL git.io/JUG7c)"
