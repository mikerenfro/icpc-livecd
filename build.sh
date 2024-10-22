#!/bin/bash
set -e

WORKDIR=~/icpc
PACKAGES="gcc-11 g++-11 build-essential emacs neovim code openjdk-17-jdk-headless pypy3"
ECLIPSE_RELEASE=2024-12
ECLIPSE_RELEASE_TYPE=M1
PYCHARM_RELEASE=2024.2.3
LICLIPSE_VERSION=11.1.0

# Hopefully nothing to change below this line

ECLIPSE_URL_BASE=https://mirror.umd.edu/eclipse/technology/epp/downloads/release
ECLIPSE_CPP_URL=${ECLIPSE_URL_BASE}/${ECLIPSE_RELEASE}/${ECLIPSE_RELEASE_TYPE}/eclipse-cpp-${ECLIPSE_RELEASE}-${ECLIPSE_RELEASE_TYPE}-linux-gtk-x86_64.tar.gz
ECLIPSE_JAVA_URL=${ECLIPSE_URL_BASE}/${ECLIPSE_RELEASE}/${ECLIPSE_RELEASE_TYPE}/eclipse-java-${ECLIPSE_RELEASE}-${ECLIPSE_RELEASE_TYPE}-linux-gtk-x86_64.tar.gz
PYCHARM_URL=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_RELEASE}.tar.gz
LICLIPSE_URL_BASE=https://www.mediafire.com/file_premium/yvh4pjh3viveurn/
LICLIPSE_URL=${LICLIPSE_URL_BASE}/liclipse_${LICLIPSE_VERSION}_linux.gtk.x86_64.tar.gz
# Dependencies
sudo apt update
sudo apt -y install live-build live-boot-doc live-config-doc

# IDE staging
for U in ${ECLIPSE_CPP_URL} ${ECLIPSE_JAVA_URL} ${PYCHARM_URL} ${LICLIPSE_URL}; do
    wget -q --mirror --no-directories --progress=bar:force:noscroll ${U}
done

ECLIPSE_DIR=${PWD}/debian-live/config/includes.chroot/opt/eclipse
if [ ! -d ${ECLIPSE_DIR} ]; then
    mkdir -p ${ECLIPSE_DIR}/{cpp,java}
    tar --strip-components=1 -C ${ECLIPSE_DIR}/cpp \
        -zxf $(basename ${ECLIPSE_CPP_URL})
    tar --strip-components=1 -C ${ECLIPSE_DIR}/java \
        -zxf $(basename ${ECLIPSE_JAVA_URL})
fi
PYCHARM_DIR=${PWD}/debian-live/config/includes.chroot/opt/pycharm
if [ ! -d ${PYCHARM_DIR} ]; then
    mkdir -p ${PYCHARM_DIR}
    tar --strip-components=1 -C ${PYCHARM_DIR} \
        -zxf $(basename ${PYCHARM_URL})
fi
LICLIPSE_DIR=${PWD}/debian-live/config/includes.chroot/opt/liclipse
if [ ! -d ${LICLIPSE_DIR} ]; then
    mkdir -p ${LICLIPSE_DIR}
    tar --strip-components=1 -C ${LICLIPSE_DIR} \
        -zxf $(basename ${LICLIPSE_URL})
fi

# VS Code staging
wget --mirror --no-directories https://packages.microsoft.com/keys/microsoft.asc
TRUSTED_GPG_DIR=debian-live/config/includes.chroot/etc/apt/trusted.gpg.d
mkdir -p ${TRUSTED_GPG_DIR}
gpg --dearmor < microsoft.asc > ${TRUSTED_GPG_DIR}/packages.microsoft.gpg

if [ "$1" == "allow-internet" ]; then
    mv debian-live/config/includes.chroot/etc/environment debian-live/config/includes.chroot/etc/_environment
    mv debian-live/config/package-lists/restrict-internet.list.chroot debian-live/config/package-lists/restrict-internet._list.chroot
fi
# Preparations
mkdir -p ${WORKDIR} && pushd ${WORKDIR}
lb config \
    --distribution bookworm \
    --bootappend-live "boot=live components quiet splash noroot toram nouveau.modeset=0" \
    --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=788 noroot toram"
rsync -av --progress ${OLDPWD}/debian-live/config/ config/

lb build

popd

if [ "$1" == "allow-internet" ]; then
    mv debian-live/config/includes.chroot/etc/_environment debian-live/config/includes.chroot/etc/environment
    mv debian-live/config/package-lists/restrict-internet._list.chroot debian-live/config/package-lists/restrict-internet.list.chroot
fi
