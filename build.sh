#!/bin/bash
set -e

# References:
# - https://askubuntu.com/a/49679
# - https://help.ubuntu.com/community/LiveCDCustomization

MAJOR_RELEASE=20.04
MINOR_RELEASE=4
WORKDIR=~/icpc-livecd
ORIG_CD=${WORKDIR}/original-cd
NEW_CD=${WORKDIR}/cd
CUSTOM=${WORKDIR}/custom
SQUASHFS=${WORKDIR}/squashfs
PACKAGES="build-essential emacs neovim code openjdk-17-jdk-headless python2.7 python3.5"
ECLIPSE_RELEASE=2021-12

# Hopefully nothing to change below this line

ISO_URL_BASE=https://cdimage.ubuntu.com/xubuntu/releases
ISO_URL=${ISO_URL_BASE}/${MAJOR_RELEASE}/release/xubuntu-${MAJOR_RELEASE}.${MINOR_RELEASE}-desktop-amd64.iso
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

# Preparations
mkdir -p ${WORKDIR} && pushd ${WORKDIR}
mkdir -p ${ORIG_CD} ${NEW_CD} ${CUSTOM} ${SQUASHFS}
wget --mirror --no-directories ${ISO_URL}
ISO_NAME=$(basename ${ISO_URL})
if mountpoint -q ${ORIG_CD}; then
    echo "${ORIG_CD} already mounted"
else
    mount -o loop ${ISO_NAME} ${ORIG_CD}
fi
rsync --update --exclude=/casper/filesystem.squashfs -a ${ORIG_CD}/ ${NEW_CD}
if mountpoint -q ${SQUASHFS}; then
    echo "${SQUASHFS} already mounted"
else
    mount -t squashfs -o loop ${ORIG_CD}/casper/filesystem.squashfs ${SQUASHFS}
fi
rsync --update -a ${SQUASHFS}/* custom
cp /etc/{resolv.conf,hosts} ${CUSTOM}/etc/
mount_pseudo_if_needed ${CUSTOM}/proc proc
mount_pseudo_if_needed ${CUSTOM}/sys sysfs
mount_pseudo_if_needed ${CUSTOM}/dev/pts devpts
# if mountpoint -q ${CUSTOM}/proc; then
#     echo "${CUSTOM}/proc already mounted"
# else
#     mount -t proc none ${CUSTOM}/proc
# fi
# if mountpoint -q ${CUSTOM}/sys; then
#     echo "${CUSTOM}/sys already mounted"
# else
#     mount -t sysfs none ${CUSTOM}/sys
# fi
# if mountpoint -q ${CUSTOM}/dev/pts; then
#     echo "${CUSTOM}/dev/pts already mounted"
# else
#     mount -t devpts none ${CUSTOM}/dev/pts
# fi

# Customizing
chroot ${CUSTOM} add-apt-repository -y ppa:deadsnakes/ppa
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > ${CUSTOM}/etc/apt/trusted.gpg.d/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > ${CUSTOM}/etc/apt/sources.list.d/vscode.list
chroot ${CUSTOM} apt -y update
chroot ${CUSTOM} apt -y upgrade
chroot ${CUSTOM} apt -y install ${PACKAGES}
# In custom/usr/share/initramfs-tools/scripts/casper-bottom/25adduser:
# - Whack sudoers entry for live user
# - Whack ubiquity.desktop file copying
# - Add secondary user with sudo and real password, or give root a public key and ssh access

# Cleaning up
chroot ${CUSTOM} apt -y clean
umount_pseudo_if_needed ${CUSTOM}/proc
umount_pseudo_if_needed ${CUSTOM}/sys
umount_pseudo_if_needed ${CUSTOM}/dev/pts
# if mountpoint -q ${CUSTOM}/proc; then
#     umount ${CUSTOM}/proc
# else
#     echo "${CUSTOM}/proc already unmounted"
# fi
# if mountpoint -q ${CUSTOM}/sys; then
#     umount ${CUSTOM}/sys
# else
#     echo "${CUSTOM}/sys already unmounted"
# fi
# if mountpoint -q ${CUSTOM}/dev/pts; then
#     umount ${CUSTOM}/dev/pts
# else
#     echo "${CUSTOM}/dev/pts already un mounted"
# fi

rm -rf ${CUSTOM}/tmp/*
rm -rf ${CUSTOM}/etc/{resolv.conf,hosts}

# Setting up the ISO
chmod +w ${NEW_CD}/casper/filesystem.manifest
chroot ${CUSTOM} dpkg-query -W --showformat='${Package} ${Version}\n' > ${NEW_CD}/casper/filesystem.manifest
cp ${NEW_CD}/casper/filesystem.manifest ${NEW_CD}/casper/filesystem.manifest-desktop
mksquashfs ${CUSTOM} ${NEW_CD}/casper/filesystem.squashfs -noappend
rm -f ${NEW_CD}/md5sum.txt
(cd ${NEW_CD} && find . -type f -exec md5sum {} + > md5sum.txt)

# Creating the ISO
cd ${NEW_CD}
mkisofs -r -V "ICPC Live" ${MKISOFS_OPTIONS} -o ${WORKDIR}/icpc-live.iso .

# Unmount and Clean
if mountpoint -q ${SQUASHFS}/; then
    umount ${SQUASHFS}
else
    echo "${SQUASHFS} already unmounted"
fi
if mountpoint -q ${ORIG_CD}; then
    umount ${ORIG_CD}
else
    echo "${ORIG_CD} already unmounted"
fi
popd
