##############################################
# ArchLinux Fast Install 
##############################################

# Описание
Этот скрипт не задумывался, как обычный установочный с большим выбором DE, разметкой диска и т.д. И он не предназначет для новичков. Он предназначет для тех, кто ставил ArchLinux руками и понимает, что и для чего нужна каждая команда. 

Его цель - это моментальное разворачиванеи системы со всеми конфигами. Смысл в том что, все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки ArchLinux с вашими личными настройками (при условии, что вы его изменили под себя, в противном случае с моими настройками).

Cкрипт основан на чек листе ручной установке ArchLinux https://vk.cc/7JTg6U
Разметка MBR c BIOS. C UEFI скрипт по ссылке https://github.com/ordanax/arch

Cостоит из 3 частей. 

Видео с демонстрацией работы скрипта https://www.youtube.com/watch?v=nvVF_qKDUeM

# Установка 
1) Скачать и записать на флешку ISO образ Arch Linux https://www.archlinux.org/download/
2) Скачать и запустить скрипт командой:

   ```bash 
   wget git.io/arch1.sh && sh arch1.sh
   ```
   Запустится установка минимальной системы.
   2-я часть ставится автоматически и это базовая установка ArchLinux без программ. 
3) 3-я часть не обязательная. Она устанавливает программы, AUR (yay), мои конфиги XFCE.
   Предварительно установите wget командой:
   ```bash 
   sudo pacman -S wget
   ```
   Установка 3-й части производится из терминала командой:
   
   ```bash 
   wget git.io/arch3.sh && sh arch3.sh
   ```

# Настройка скрипта под себя
Вы можете форкнуть этот срипт. Изменить разметку дисков под свои нужды, сделать копию собственного конфга XFCE, залить его на Github и производить быстрое разворачивание вашей системы.
По завершению работы скрипта вы получаете вашу готовую и настроенную систему со всеми конфигами. Вам ее нужно лишь немного привести в порядок и все.
Как и что менять написано в комментариях в самом скрипте.

# ВНИМАНИЕ!
Автор не несет ответственности за любое нанесение вреда при использовании скрипта. Используйте его на свой страх и риск или изменяйте под свои личные нужды.

Скрипт затирает диск dev/sda в системе. Поэтому если у вас есть ценные данные на дисках сохраните их. Если вам нужна установка рядом с Windows, тогда вам нужно предварительно изменить скрипт и разметить диски. В противном случае данные и Windows будут затерты.

Если вам не подходит автоматическая разметка дисков, тогда вам, предварительно нужно сделать разметку дисков и настроить скрипт под свои нужды (программы, XFCE config и т.д.)
Смотрите комментарии в самом скрипте.
