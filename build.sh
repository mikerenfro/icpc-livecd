#!/bin/bash
set -Eeuo pipefail

catch_error() {
    local exit_code=$?
    local line_number=$1
    echo "Error occurred on line $line_number with exit code $exit_code" >&2

    # Perform cleanup actions here (e.g., removing temp files)
    cd ${STARTDIR}
    exit "$exit_code"
}

trap 'catch_error $LINENO' ERR INT

function allow_internet() {
    # No-op for now
    echo "Ensuring Internet access stays enabled"
}

function forbid_internet() {
    # Ensure Internet-restricting files exist in ${CHROOT}
    echo "Restricting Internet access via /etc/{environment,shorewall}"
    cp ${STARTDIR}/internet-restrictions/environment ${CHROOT}/etc/
    perl -pi -e "s/__SQUID_IP__/${SQUID_IP}/g" ${CHROOT}/etc/environment
    cp -a ${STARTDIR}/internet-restrictions/shorewall ${CHROOT}/etc/
    perl -pi -e "s/__SQUID_IP__/${SQUID_IP}/g" ${CHROOT}/etc/shorewall/rules
    cp ${STARTDIR}/internet-restrictions/restrict-internet.list.chroot ${WORKDIR}/config/package-lists/
}

function install_supported_languages() {
    echo -ne "Adding language support: "
    cp ${STARTDIR}/languages/*.{ans,in} ${STARTDIR}/languages/Makefile ${CHROOT}/etc/skel/Desktop/test-compilers/
    > ${CHROOT}/opt/languages.md
    for LANGUAGE in ${LANGUAGES}; do
        echo -ne "${LANGUAGE} "
        cp ${STARTDIR}/languages/${LANGUAGE}/${LANGUAGE}.list.chroot ${WORKDIR}/config/package-lists/
        cp ${STARTDIR}/languages/${LANGUAGE}/hooks/* ${WORKDIR}/config/hooks/live/
        cp ${STARTDIR}/languages/${LANGUAGE}/test-compilers/* ${CHROOT}/etc/skel/Desktop/test-compilers/
        ${STARTDIR}/languages/${LANGUAGE}/${LANGUAGE}_filter_md.sh < ${STARTDIR}/languages/${LANGUAGE}/${LANGUAGE}.md >> ${CHROOT}/opt/languages.md
    done
    echo "done."
}

function install_supported_ides() {
    echo "Installing optional IDEs (if any): "
    > ${CHROOT}/opt/ide-versions
    > ${CHROOT}/opt/ides.md
    for IDE in ${IDES}; do
        if [ -f ${STARTDIR}/ides/${IDE}/functions.sh ]; then
            . ${STARTDIR}/ides/${IDE}/functions.sh
            install_ide
        else
            echo "Can't find ${STARTDIR}/ides/${IDE}/functions.sh"
            exit 1
        fi
    done
    echo "done."
}

WORKDIR=~/icpc
SQUID_IP=149.149.254.4
LANGUAGES="c c++ java python"
IDES="eclipse liclipse pycharm vscode"

# Hopefully nothing to change below this line
STARTDIR=${PWD}
WGET="wget --no-clobber -q"
DEBIAN_RELEASE=trixie

CHROOT=${WORKDIR}/config/includes.chroot

# Dependencies
echo "Installing live-build and dependencies"
sudo apt-get update
sudo apt-get -y install gpg live-build live-boot-doc live-config-doc zstd

if [ "$#" == "1" ]; then
    if [ "$1" == "allow-internet" ]; then
        ALLOW_INTERNET=1
    else
        ALLOW_INTERNET=0
    fi
else
    ALLOW_INTERNET=0
fi

# Preparations
echo "Cleaning out and recreating ${WORKDIR}"
sudo rm -rf ${WORKDIR} && mkdir -p ${WORKDIR}

pushd ${WORKDIR}

lb config \
    --distribution ${DEBIAN_RELEASE} \
    --apt-recommends false \
    --bootappend-live "boot=live components quiet splash noroot toram nouveau.modeset=0" \
    --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=788 noroot toram"

echo "Syncing debian-live/config contents"
rsync -a ${STARTDIR}/debian-live/config/ config/
if [ "${ALLOW_INTERNET}" == "1" ]; then
    allow_internet
else
    forbid_internet
fi

install_supported_languages
install_supported_ides

echo "Copying README markdown content"
cp -a ${STARTDIR}/team-readme-files ${CHROOT}/opt/

echo "$(date): building live CD"
sudo lb build >> ~/icpc-build.out 2>&1
echo "$(date): done"

popd

if [ "${ALLOW_INTERNET}" == "1" ]; then
    FINAL_ISO=~/icpc-livecd-with-internet-amd64.hybrid.iso
else
    FINAL_ISO=~/icpc-livecd-without-internet-amd64.hybrid.iso
fi
mv -vf ${WORKDIR}/live-image-amd64.hybrid.iso ${FINAL_ISO}
