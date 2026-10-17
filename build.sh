#!/bin/bash
set -Eeuo pipefail

catch_error() {
    local exit_code=$?
    local line_number=$1
    echo "Error occurred on line $line_number with exit code $exit_code" >&2
    
    # Perform cleanup actions here (e.g., removing temp files)
    echo "Restoring /opt, applications, Internet restrictions"
    cd ${STARTDIR}
    if [ "${ALLOW_INTERNET}" == "1" ]; then
        forbid_internet
    fi
    exit "$exit_code"
}

trap 'catch_error $LINENO' ERR INT

function install_eclipse() {
    echo -ne "Eclipse "
    (cd ${STARTDIR}
    for language in ${ECLIPSE_LANGUAGES}; do
        url=https://${ECLIPSE_MIRROR}/eclipse/technology/epp/downloads/release/${ECLIPSE_RELEASE}/R/eclipse-${language}-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
        ${WGET} --progress=dot:giga --no-clobber ${url}
    done)

    ECLIPSE_DIR=${CHROOT}/opt/eclipse
    for language in ${ECLIPSE_LANGUAGES}; do
        echo -ne "(for ${language}) "
        mkdir -p ${ECLIPSE_DIR}/${language}
        tarball=${STARTDIR}/eclipse-${language}-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
        echo "Extracting Eclipse ${language}"
        tar -zxf ${tarball} --strip-components=1 -C ${ECLIPSE_DIR}/${language}
        case ${language} in
            cpp) shortcut="Eclipse-C++";;
            java) shortcut="Eclipse-Java";;
        esac
        cp ${STARTDIR}/applications/${shortcut}.desktop ${CHROOT}/usr/share/applications/
    done
}

function install_liclipse() {
    echo -ne "Liclipse "
    (cd ${STARTDIR} && ${WGET} ${LICLIPSE_URL})
    LICLIPSE_DIR=${CHROOT}/opt/liclipse
    echo "Extracting LiClipse"
    mkdir -p ${LICLIPSE_DIR}
    tar --strip-components=1 -C ${LICLIPSE_DIR} \
        -zxf ${STARTDIR}/$(basename ${LICLIPSE_URL})
    cp ${STARTDIR}/applications/LiClipse.desktop ${CHROOT}/usr/share/applications/
}

function install_pycharm() {
    echo -ne "Pycharm "
    (cd ${STARTDIR} && ${WGET} ${PYCHARM_URL})
    PYCHARM_DIR=${CHROOT}/opt/pycharm
    echo "Extracting PyCharm"
    mkdir -p ${PYCHARM_DIR}
    tar --strip-components=1 -C ${PYCHARM_DIR} \
        -zxf ${STARTDIR}/$(basename ${PYCHARM_URL})
    cp ${STARTDIR}/applications/PyCharm.desktop ${CHROOT}/usr/share/applications/
}

function install_vscode() {
    echo -ne "VS Code "
    (cd ${STARTDIR}
    wget --mirror --no-directories https://packages.microsoft.com/keys/microsoft-2025.asc
    )
    TRUSTED_GPG_DIR=${CHROOT}/etc/apt/trusted.gpg.d
    mkdir -p ${TRUSTED_GPG_DIR}
    gpg --dearmor < ${STARTDIR}/microsoft-2025.asc > ${TRUSTED_GPG_DIR}/packages.microsoft.gpg
    cp ${STARTDIR}/applications/VS-Code.desktop ${CHROOT}/usr/share/applications/
}

function allow_internet() {
    # No-op for now
    echo "Ensuring Internet access stays enabled"    
}

function forbid_internet() {
    # Ensure Internet-restricting files exist in ${CHROOT}
    echo "Restricting Internet access via /etc/{environment,shorewall}"
    cp ${STARTDIR}/internet-restrictions/environment ${CHROOT}/etc/
    cp -a ${STARTDIR}/internet-restrictions/shorewall ${CHROOT}/etc/
    cp ${STARTDIR}/internet-restrictions/restrict-internet.list.chroot ${WORKDIR}/config/package-lists/
}

STARTDIR=${PWD}
WORKDIR=~/icpc
ECLIPSE_RELEASE=2026-09
ECLIPSE_LANGUAGES="cpp java"
ECLIPSE_MIRROR=mirror.umd.edu
LICLIPSE_RELEASE=12.0.1
PYCHARM_RELEASE=2026.2.3

# Hopefully nothing to change below this line
WGET="wget --progress=dot:giga --no-clobber"
PYCHARM_URL=https://download.jetbrains.com/python/pycharm-${PYCHARM_RELEASE}.tar.gz
LICLIPSE_URL=https://www.mediafire.com/file_premium/cj9sxqllqjivuya/liclipse_${LICLIPSE_RELEASE}_linux.gtk.x86_64.tar.gz

CHROOT=${WORKDIR}/config/includes.chroot

# Dependencies
sudo apt-get update
sudo apt-get -y install gpg live-build live-boot-doc live-config-doc zstd

if [ "$1" == "allow-internet" ]; then
    ALLOW_INTERNET=1
else
    ALLOW_INTERNET=0
fi

# Preparations
echo "Cleaning out and recreating ${WORKDIR}"
sudo rm -rf ${WORKDIR} && mkdir -p ${WORKDIR} && pushd ${WORKDIR}
lb config \
    --distribution trixie \
    --apt-recommends false \
    --bootappend-live "boot=live components quiet splash noroot toram nouveau.modeset=0" \
    --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=788 noroot toram"

echo "Syncing debian-live/config contents"
rsync -a ${STARDIR}/debian-live/config/ config/
if [ "${ALLOW_INTERNET}" == "1" ]; then
    allow_internet
else
    forbid_internet
fi

echo -ne "Installing optional IDEs (if any): "
install_eclipse
install_liclipse
install_pycharm
install_vscode
echo "done."
echo "$(date): building live CD"
sudo lb build >> ~/icpc-build.out 2>&1
echo "$(date): done"

popd

if [ "${ALLOW_INTERNET}" == "1" ]; then
    mv -v ${WORKDIR}/live-image-amd64.hybrid.iso ~/icpc-livecd-with-internet-amd64.hybrid.iso
    forbid_internet
else
    mv -v ${WORKDIR}/live-image-amd64.hybrid.iso ~/icpc-livecd-without-internet-amd64.hybrid.iso
fi
