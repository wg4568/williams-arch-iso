#! /bin/bash

source ./options.conf

if [[ $1 = *[0-9] ]]; then
    PART1="$1p1"
    PART2="$1p2"
    PART3="$1p3"
else
    PART1="$11"
    PART2="$12"
    PART3="$13"
fi

echo "Attempting to unmount if already mounted..."
umount $PART1
umount $PART3
swapoff $PART2

read -p "You are about to delete ALL data on $1, proceed? [y/n] " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]] then
    echo "Exited."
    exit 0
fi

echo "=============================="
echo "= DISK PARTITIONING          ="
echo "=============================="
echo -e $PARTITIONS | sfdisk $1

if [ $? -ne 0 ]; then
    echo "Partitioning failed, drives are probably mounted."
    exit 1
fi

echo "=============================="
echo "= WRITE FILESYSTEM           ="
echo "=============================="
mkfs.fat -F 32 $PART1
mkswap $PART2
mkfs.ext4 -F $PART3

echo "=============================="
echo "= MOUNT PARTITIONS           ="
echo "=============================="
mount $PART3 /mnt
mkdir -p /mnt/boot/efi
mount $PART1 /mnt/boot/efi
swapon $PART2

echo "=============================="
echo "= INSTALL SYSTEM             ="
echo "=============================="
pacman -Syyy
echo $PACKAGES | xargs pacstrap /mnt
genfstab -U /mnt > /mnt/etc/fstab

echo "=============================="
echo "= CONFIGURE BOOTLOADER       ="
echo "=============================="
arch-chroot /mnt grub-install $1
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "=============================="
echo "= CONFIGURE SYSTEM           ="
echo "=============================="
arch-chroot /mnt ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
arch-chroot /mnt hwclock --systohc

sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /mnt/etc/locale.gen
echo 'LANG=en_US.UTF' > /mnt/etc/locale.conf
arch-chroot /mnt locale-gen

echo $HOSTNAME > /mnt/etc/hostname
arch-chroot /mnt systemctl enable NetworkManager

arch-chroot /mnt passwd

echo "Done."
