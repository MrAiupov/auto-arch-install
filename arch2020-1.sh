#!/bin/bash

# Arch Linux Fast Install - Быстрая установка Arch Linux https://github.com/ordanax/arch2018
# Цель скрипта - быстрое развертывание системы с вашими персональными настройками (конфиг XFCE, темы, программы и т.д.).

# В разработке принимали участие:
# Алексей Бойко https://vk.com/ordanax
# Степан Скрябин https://vk.com/zurg3
# Михаил Сарвилин https://vk.com/michael170707
# Данил Антошкин https://vk.com/danil.antoshkin
# Юрий Порунцов https://vk.com/poruncov

loadkeys ru
setfont cyr-sun16
echo 'Скрипт сделан на основе чеклиста Бойко Алексея по Установке ArchLinux'
echo 'Ссылка на чек лист есть в группе vk.com/arch4u'

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo '2.4 создание разделов'
(
  echo o;

  echo n;
  echo;
  echo;
  echo;
  echo +500M;

  echo n;
  echo;
  echo;
  echo;
  echo +20G;

  echo n;
  echo;
  echo;
  echo;
  echo +4096M;

  echo n;
  echo p;
  echo;
  echo;
  echo a;
  echo 1;

  echo w;
) | fdisk /dev/sda

echo 'Ваша разметка диска'
fdisk -l

echo '2.4.2 Форматирование дисков'
mkfs.ext2  /dev/sda1 -L boot
mkfs.ext4  /dev/sda2 -L root
mkswap /dev/sda3 -L swap
mkfs.ext4  /dev/sda4 -L home

echo '2.4.3 Монтирование дисков'
mount /dev/sda2 /mnt
mkdir /mnt/{boot,home,hard1}
mount /dev/sda1 /mnt/boot
swapon /dev/sda3
mount /dev/sda4 /mnt/home
mount /dev/sdb1 /mnt/hard1

echo '3.1 Выбор зеркал для загрузки. Ставим зеркала для России'
echo "##" > /etc/pacman.d/mirrorlist
echo "##Arch Linux repository mirrorlist" >> /etc/pacman.d/mirrorlist
echo "##Generated on 2020-02-19" >> /etc/pacman.d/mirrorlist
echo "##" >> /etc/pacman.d/mirrorlist
echo "##Russia" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.yandex.ru/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.truenetwork.ru/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirror.rol.ru/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = https://mirror.rol.ru/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://archlinux.zepto.cloud/$repo/os/$arch" >> /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/JvnRM)"
