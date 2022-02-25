#!/bin/bash
set -e

# Reference: https://askubuntu.com/a/49679

ISO_URL=https://cdimage.ubuntu.com/xubuntu/releases/20.04/release/xubuntu-20.04.4-desktop-amd64.iso
WORKDIR=~/icpc-livecd

# Preparations
mkdir -p ${WORKDIR} && pushd ${WORKDIR}
mkdir -p original-cd cd custom squashfs
wget --mirror --no-directories ${ISO_URL}
ISO_NAME=$(basename ${ISO_URL})
mount -o loop ${ISO_NAME} original-cd
rsync --exclude=/casper/filesystem.squashfs -a original-cd/ cd
mount -t squashfs -o loop original-cd/casper/filesystem.squashfs squashfs
cp -a squashfs/* custom
cp /etc/{resolv.conf,hosts} custom/etc/
mount -t proc none custom/proc
mount -t sysfs none custom/sys

# Customizing
chroot custom add-apt-repository -y ppa:deadsnakes/ppa
chroot custom apt -y install build-essential emacs vim openjdk-17-jdk-headless python2.7 python3.5

# Cleaning up
chroot custom apt -y clean
umount custom/proc
umount custom/sys
rm -rf custom/tmp/*
rm -rf custom/etc/{resolv.conf,hosts}

# Setting up the ISO
chmod +w cd/casper/filesystem.manifest
sudo chroot custom dpkg-query -W --showformat='${Package} ${Version}\n' > cd/casper/filesystem.manifest
sudo cp cd/casper/filesystem.manifest cd/casper/filesystem.manifest-desktop
mksquashfs custom cd/casper/filesystem.squashfs
rm -f cd/md5sum.txt
(cd cd && find . -type f -exec md5sum {} + > md5sum.txt)

# Creating the ISO
cd cd
mkisofs -r -V "ICPC Live" -b isolinux/isolinux.bin -c isolinux/boot.cat -cache-inodes -J -l -no-emul-boot -boot-load-size 4 -boot-info-table -o ${WORKDIR}/icpc-live.iso .

# Unmount and Clean
umount ${WORKDIR}/squashfs/
umount ${WORKDIR}/livecd/
