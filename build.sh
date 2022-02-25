#!/bin/bash
set -e

# Reference: https://askubuntu.com/a/49679

MAJOR_RELEASE=20.04
MINOR_RELEASE=4
WORKDIR=~/icpc-livecd
ORIG_CD=${WORKDIR}/original-cd
NEW_CD=${WORKDIR}/cd
CUSTOM=${WORKDIR}/custom
SQUASHFS=${WORKDIR}/squashfs

ISO_URL=https://cdimage.ubuntu.com/xubuntu/releases/${MAJOR_RELEASE}/release/xubuntu-${MAJOR_RELEASE}.${MINOR_RELEASE}-desktop-amd64.iso

# Preparations
mkdir -p ${WORKDIR} && pushd ${WORKDIR}
mkdir -p ${ORIG_CD} ${NEW_CD} ${CUSTOM} ${SQUASHFS}
wget --mirror --no-directories ${ISO_URL}
ISO_NAME=$(basename ${ISO_URL})
mount -o loop ${ISO_NAME} ${ORIG_CD}
rsync --exclude=/casper/filesystem.squashfs -a ${ORIG_CD}/ ${NEW_CD}
mount -t squashfs -o loop ${ORIG_CD}/casper/filesystem.squashfs ${SQUASHFS}
cp -a ${SQUASHFS}/* custom
cp /etc/{resolv.conf,hosts} ${CUSTOM}/etc/
mount -t proc none ${CUSTOM}/proc
mount -t sysfs none ${CUSTOM}/sys

# Customizing
chroot ${CUSTOM} add-apt-repository -y ppa:deadsnakes/ppa
chroot ${CUSTOM} apt -y upgrade
chroot ${CUSTOM} apt -y install build-essential emacs vim openjdk-17-jdk-headless python2.7 python3.5

# Cleaning up
chroot ${CUSTOM} apt -y clean
umount ${CUSTOM}/proc
umount ${CUSTOM}/sys
rm -rf ${CUSTOM}/tmp/*
rm -rf ${CUSTOM}/etc/{resolv.conf,hosts}

# Setting up the ISO
chmod +w ${NEW_CD}/casper/filesystem.manifest
sudo chroot ${CUSTOM} dpkg-query -W --showformat='${Package} ${Version}\n' > ${NEW_CD}/casper/filesystem.manifest
sudo cp ${NEW_CD}/casper/filesystem.manifest ${NEW_CD}/casper/filesystem.manifest-desktop
mksquashfs ${CUSTOM} ${NEW_CD}/casper/filesystem.squashfs
rm -f ${NEW_CD}/md5sum.txt
(cd ${NEW_CD} && find . -type f -exec md5sum {} + > md5sum.txt)

# Creating the ISO
cd ${NEW_CD}
MKISOFS_OPTIONS="-b isolinux/isolinux.bin -c isolinux/boot.cat -cache-inodes -J -l -no-emul-boot -boot-load-size 4 -boot-info-table"
mkisofs -r -V "ICPC Live" ${MKISOFS_OPTIONS} -o ${WORKDIR}/icpc-live.iso .

# Unmount and Clean
umount ${WORKDIR}/squashfs/
umount ${WORKDIR}/original-cd/
popd
