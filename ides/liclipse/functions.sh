function install_ide() {
    echo "- Liclipse"

    HERE=${STARTDIR}/ides/${IDE}

    LICLIPSE_RELEASE=12.0.1
    LICLIPSE_URL=https://www.mediafire.com/file_premium/cj9sxqllqjivuya/liclipse_${LICLIPSE_RELEASE}_linux.gtk.x86_64.tar.gz
    (cd ${STARTDIR} && ${WGET} ${LICLIPSE_URL})
    LICLIPSE_DIR=${CHROOT}/opt/liclipse
    mkdir -p ${LICLIPSE_DIR}
    tar --strip-components=1 -C ${LICLIPSE_DIR} \
        -zxf ${STARTDIR}/$(basename ${LICLIPSE_URL})
    cp ${HERE}/LiClipse.desktop ${CHROOT}/usr/share/applications/
    cp ${HERE}/hooks/*.hook.chroot ${WORKDIR}/config/hooks/live/
    echo "LICLIPSE_RELEASE=${LICLIPSE_RELEASE}" >> ${CHROOT}/opt/ide-versions
    echo "- LiClipse __LICLIPSE_VERSION__ (for Python)" >> ${CHROOT}/opt/ides.md
}
