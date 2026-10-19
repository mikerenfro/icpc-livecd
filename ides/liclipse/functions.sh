function install_ide() {
    echo "- Liclipse"

    HERE=${STARTDIR}/ides/${IDE}

    LICLIPSE_URL=https://www.mediafire.com/file_premium/cj9sxqllqjivuya/liclipse_${LICLIPSE_RELEASE}_linux.gtk.x86_64.tar.gz
    LICLIPSE_RELEASE=12.0.1
    (cd ${STARTDIR} && ${WGET} ${LICLIPSE_URL})
    LICLIPSE_DIR=${CHROOT}/opt/liclipse
    mkdir -p ${LICLIPSE_DIR}
    tar --strip-components=1 -C ${LICLIPSE_DIR} \
        -zxf ${STARTDIR}/$(basename ${LICLIPSE_URL})
    cp ${HERE}/shortcuts/LiClipse.desktop ${CHROOT}/usr/share/applications/
    echo "LICLIPSE_RELEASE=${LICLIPSE_RELEASE}" >> ${CHROOT}/opt/ide-versions
    echo "- LiClipse __LICLIPSE_VERSION__ (for Python)" >> ${CHROOT}/opt/ides.md
}
