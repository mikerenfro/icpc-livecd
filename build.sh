#!/bin/bash
set -e

WORKDIR=~/icpc
PYCHARM_RELEASE=2024.2.4

# Hopefully nothing to change below this line

PYCHARM_URL=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_RELEASE}.tar.gz
# Dependencies
sudo apt-get update
sudo apt-get -y install live-build live-boot-doc live-config-doc zstd

# IDE staging
for U in ${PYCHARM_URL}; do
    wget -q --mirror --no-directories --progress=bar:force:noscroll ${U}
done

ECLIPSE_DIR=${PWD}/debian-live/config/includes.chroot/opt/eclipse
if [ ! -d ${ECLIPSE_DIR} ]; then
    echo "Extracting Eclipse"
    mkdir -p ${ECLIPSE_DIR}
    tar --strip-components=1 -C ${ECLIPSE_DIR} \
        -zxf eclipse.tgz
else
   echo "Eclipse already extracted, skipping"
fi
PYCHARM_DIR=${PWD}/debian-live/config/includes.chroot/opt/pycharm
if [ ! -d ${PYCHARM_DIR} ]; then
    echo "Extracting PyCharm"
    mkdir -p ${PYCHARM_DIR}
    tar --strip-components=1 -C ${PYCHARM_DIR} \
        -zxf $(basename ${PYCHARM_URL})
else
    echo "PyCharm already extracted, skipping"
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
    --apt-recommends false \
    --bootappend-live "boot=live components quiet splash noroot toram nouveau.modeset=0" \
    --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=788 noroot toram"
echo "Syncing debian-live/config contents"
rsync -a ${OLDPWD}/debian-live/config/ config/

lb build

popd

if [ "$1" == "allow-internet" ]; then
    mv debian-live/config/includes.chroot/etc/_environment debian-live/config/includes.chroot/etc/environment
    mv debian-live/config/package-lists/restrict-internet._list.chroot debian-live/config/package-lists/restrict-internet.list.chroot
fi
