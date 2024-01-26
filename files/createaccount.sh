#! /bin/bash

read -p "Username: " NEWUSER
arch-chroot /mnt useradd -m -s /bin/bash $NEWUSER
echo "$NEWUSER ALL=(ALL:ALL) ALL" | arch-chroot /mnt EDITOR="tee -a" visudo
arch-chroot /mnt passwd $NEWUSER
cp ./.postinstall /mnt/home/$NEWUSER/postinstall.sh
