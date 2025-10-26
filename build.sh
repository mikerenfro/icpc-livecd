#!/bin/bash
set -e

WORKDIR=~/icpc
ECLIPSE_RELEASE=2025-09
ECLIPSE_LANGUAGES="cpp java"
ECLIPSE_MIRROR=mirror.umd.edu
LICLIPSE_RELEASE=12.0.1
PYCHARM_RELEASE=2025.2.3

# Hopefully nothing to change below this line
WGET="wget --progress=dot:giga --no-clobber"
PYCHARM_URL=https://download-cdn.jetbrains.com/python/pycharm-${PYCHARM_RELEASE}.tar.gz
LICLIPSE_URL=https://www.mediafire.com/file_premium/cj9sxqllqjivuya/liclipse_${LICLIPSE_RELEASE}_linux.gtk.x86_64.tar.gz

# Dependencies
sudo apt-get update
sudo apt-get -y install gpg live-build live-boot-doc live-config-doc zstd

# IDE staging
for U in ${PYCHARM_URL} ${LICLIPSE_URL}; do
    ${WGET} --progress=dot:giga --no-clobber ${U}
done
for language in ${ECLIPSE_LANGUAGES}; do
    url=https://${ECLIPSE_MIRROR}/eclipse/technology/epp/downloads/release/${ECLIPSE_RELEASE}/R/eclipse-${language}-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
    ${WGET} --progress=dot:giga --no-clobber ${url}
done

ECLIPSE_DIR=${PWD}/debian-live/config/includes.chroot/opt/eclipse
for language in ${ECLIPSE_LANGUAGES}; do
    echo "Extracting Eclipse ${language}"
    mkdir -p ${ECLIPSE_DIR}/${language}
    tarball=${PWD}/eclipse-${language}-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
    echo "Extracting Eclipse ${language}"
    tar -zxf ${tarball} --strip-components=1 -C ${ECLIPSE_DIR}/${language}
done

PYCHARM_DIR=${PWD}/debian-live/config/includes.chroot/opt/pycharm
echo "Extracting PyCharm"
mkdir -p ${PYCHARM_DIR}
tar --strip-components=1 -C ${PYCHARM_DIR} \
    -zxf pycharm-${PYCHARM_RELEASE}.tar.gz

LICLIPSE_DIR=${PWD}/debian-live/config/includes.chroot/opt/liclipse
echo "Extracting LiClipse"
mkdir -p ${LICLIPSE_DIR}
tar --strip-components=1 -C ${LICLIPSE_DIR} \
    -zxf ${PWD}/liclipse_${LICLIPSE_RELEASE}_linux.gtk.x86_64.tar.gz

# VS Code staging
wget --mirror --no-directories https://packages.microsoft.com/keys/microsoft-2025.asc
TRUSTED_GPG_DIR=debian-live/config/includes.chroot/etc/apt/trusted.gpg.d
mkdir -p ${TRUSTED_GPG_DIR}
gpg --dearmor < microsoft-2025.asc > ${TRUSTED_GPG_DIR}/packages.microsoft.gpg

if [ "$1" == "allow-internet" ]; then
    mv debian-live/config/includes.chroot/etc/environment debian-live/config/includes.chroot/etc/_environment
    mv debian-live/config/package-lists/restrict-internet.list.chroot debian-live/config/package-lists/restrict-internet._list.chroot
fi
# Preparations
mkdir -p ${WORKDIR} && pushd ${WORKDIR}
lb config \
    --distribution trixie \
    --apt-recommends false \
    --bootappend-live "boot=live components quiet splash noroot toram nouveau.modeset=0" \
    --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=788 noroot toram"
echo "Syncing debian-live/config contents"
rsync -a ${OLDPWD}/debian-live/config/ config/

echo "$(date): building live CD"
sudo lb build >> ~/icpc-build.out 2>&1
echo "$(date): done"

popd

if [ "$1" == "allow-internet" ]; then
    mv debian-live/config/includes.chroot/etc/_environment debian-live/config/includes.chroot/etc/environment
    mv debian-live/config/package-lists/restrict-internet._list.chroot debian-live/config/package-lists/restrict-internet.list.chroot
    mv -v ${WORKDIR}/live-image-amd64.hybrid.iso ~/icpc-livecd-with-internet-amd64.hybrid.iso
else
    mv -v ${WORKDIR}/live-image-amd64.hybrid.iso ~/icpc-livecd-without-internet-amd64.hybrid.iso
fi
