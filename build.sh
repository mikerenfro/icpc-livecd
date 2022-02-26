#!/bin/bash
set -e

# References:

MAJOR_RELEASE=11.2.0
WORKDIR=~/icpc
ORIG_CD=${WORKDIR}/original-cd
NEW_CD=${WORKDIR}/cd
CUSTOM=${WORKDIR}/custom
SQUASHFS=${WORKDIR}/squashfs
PACKAGES="build-essential emacs neovim code openjdk-17-jdk-headless python2.7 python3.5"
ECLIPSE_RELEASE=2021-12

# Hopefully nothing to change below this line

ISO_URL_BASE=https://cdimage.debian.org/debian-cd/${MAJOR_RELEASE}-live/amd64/iso-hybrid
ISO_URL=${ISO_URL_BASE}/debian-live-${MAJOR_RELEASE}-amd64-xfce.iso
MKISOFS_OPTIONS="-b isolinux/isolinux.bin -c isolinux/boot.cat -cache-inodes -J -l -no-emul-boot -boot-load-size 4 -boot-info-table"
ECLIPSE_URL_BASE=https://mirror.umd.edu/eclipse/technology/epp/downloads/release
ECLIPSE_CPP_URL=${ECLIPSE_URL_BASE}/${ECLIPSE_RELEASE}/R/eclipse-cpp-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
ECLIPSE_JAVA_URL=${ECLIPSE_URL_BASE}/${ECLIPSE_RELEASE}/R/eclipse-java-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz

function mount_pseudo_if_needed {
    if mountpoint -q $1; then
        echo "$1 already mounted"
    else
        mount -t $2 none $1
    fi
}
function umount_pseudo_if_needed {
    if mountpoint -q $1; then
        umount $1
    else
        echo "$1 already unmounted"
    fi
}

# Dependencies
apt -y install live-build live-boot-doc live-config-doc

# Preparations
mkdir -p ${WORKDIR} && pushd ${WORKDIR}
lb config \
    --bootappend-live "boot=live components quiet splash noroot" \
    --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=788 noroot"
rsync -av --progress ${OLDPWD}/debian-live/config/ config/

# VS Code
#wget --mirror --no-directories https://packages.microsoft.com/keys/microsoft.asc
#cp microsoft.asc config/archives/code.key.binary
#cp microsoft.asc config/archives/code.key.chroot
# gpg --dearmor < microsoft.asc > config/archives/vscode.key.chroot
# cp config/archives/vscode.key.chroot config/archives/vscode.key.binary
lb build

popd
