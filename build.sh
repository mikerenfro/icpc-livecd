#!/bin/bash
set -e

WORKDIR=~/icpc
PACKAGES="build-essential emacs neovim code openjdk-17-jdk-headless python2.7 python3.9"
ECLIPSE_RELEASE=2023-12
PYCHARM_RELEASE=2023.3.3

# Hopefully nothing to change below this line

ECLIPSE_URL_BASE=https://mirror.umd.edu/eclipse/technology/epp/downloads/release
ECLIPSE_CPP_URL=${ECLIPSE_URL_BASE}/${ECLIPSE_RELEASE}/R/eclipse-cpp-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
ECLIPSE_JAVA_URL=${ECLIPSE_URL_BASE}/${ECLIPSE_RELEASE}/R/eclipse-java-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
PYCHARM_URL=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_RELEASE}.tar.gz
# Dependencies
apt update
apt -y install live-build live-boot-doc live-config-doc

# Eclipse staging
wget --mirror --no-directories ${ECLIPSE_CPP_URL}
wget --mirror --no-directories ${ECLIPSE_JAVA_URL}
wget --mirror --no-directories ${PYCHARM_URL}

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

# VS Code staging
wget --mirror --no-directories https://packages.microsoft.com/keys/microsoft.asc
TRUSTED_GPG_DIR=debian-live/config/includes.chroot/etc/apt/trusted.gpg.d
mkdir -p ${TRUSTED_GPG_DIR}
gpg --dearmor < microsoft.asc > ${TRUSTED_GPG_DIR}/packages.microsoft.gpg

# Preparations
mkdir -p ${WORKDIR} && pushd ${WORKDIR}
lb config \
    --distribution bookworm \
    --bootappend-live "boot=live components quiet splash noroot toram" \
    --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=788 noroot toram"
rsync -av --progress ${OLDPWD}/debian-live/config/ config/

lb build

popd
