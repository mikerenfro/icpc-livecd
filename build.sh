#!/bin/bash
set -e

# References:

MAJOR_RELEASE=11.2.0
WORKDIR=~/icpc
PACKAGES="build-essential emacs neovim code openjdk-17-jdk-headless python2.7 python3.5"
ECLIPSE_RELEASE=2021-12

# Hopefully nothing to change below this line

ISO_URL_BASE=https://cdimage.debian.org/debian-cd/${MAJOR_RELEASE}-live/amd64/iso-hybrid
ISO_URL=${ISO_URL_BASE}/debian-live-${MAJOR_RELEASE}-amd64-xfce.iso
MKISOFS_OPTIONS="-b isolinux/isolinux.bin -c isolinux/boot.cat -cache-inodes -J -l -no-emul-boot -boot-load-size 4 -boot-info-table"
ECLIPSE_URL_BASE=https://mirror.umd.edu/eclipse/technology/epp/downloads/release
ECLIPSE_CPP_URL=${ECLIPSE_URL_BASE}/${ECLIPSE_RELEASE}/R/eclipse-cpp-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
ECLIPSE_JAVA_URL=${ECLIPSE_URL_BASE}/${ECLIPSE_RELEASE}/R/eclipse-java-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz

# Dependencies
apt -y install live-build live-boot-doc live-config-doc

# Eclipse staging
wget --mirror --no-directories ${ECLIPSE_CPP_URL}
wget --mirror --no-directories ${ECLIPSE_JAVA_URL}
ECLIPSE_DIR=${PWD}/debian-live/config/includes.chroot/opt/eclipse
mkdir -p ${ECLIPSE_DIR}/{cpp,java}
tar --strip-components=1 -C ${ECLIPSE_DIR}/cpp \
    -zxf $(basename ${ECLIPSE_CPP_URL})
tar --strip-components=1 -C ${ECLIPSE_DIR}/java \
    -zxf $(basename ${ECLIPSE_JAVA_URL})

# VS Code staging
wget --mirror --no-directories https://packages.microsoft.com/keys/microsoft.asc
TRUSTED_GPG_DIR=debian-live/config/includes.chroot/etc/apt/trusted.gpg.d
mkdir -p ${TRUSTED_GPG_DIR}
gpg --dearmor < microsoft.asc > ${TRUSTED_GPG_DIR}/packages.microsoft.gpg

# Preparations
mkdir -p ${WORKDIR} && pushd ${WORKDIR}
lb config \
    --bootappend-live "boot=live components quiet splash noroot" \
    --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=788 noroot"
rsync -av --progress ${OLDPWD}/debian-live/config/ config/

lb build

popd
