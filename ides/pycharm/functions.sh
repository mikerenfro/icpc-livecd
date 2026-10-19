function install_ide() {
    echo -ne "- Eclipse "

    HERE=${STARTDIR}/ides/${IDE}

    echo "- Pycharm"
    PYCHARM_RELEASE=2026.2.3
    PYCHARM_URL=https://download.jetbrains.com/python/pycharm-${PYCHARM_RELEASE}.tar.gz

    (cd ${STARTDIR} && ${WGET} ${PYCHARM_URL})
    PYCHARM_DIR=${CHROOT}/opt/pycharm
    mkdir -p ${PYCHARM_DIR}
    tar --strip-components=1 -C ${PYCHARM_DIR} \
        -zxf ${STARTDIR}/$(basename ${PYCHARM_URL})
    cp ${HERE}/PyCharm.desktop ${CHROOT}/usr/share/applications/
    echo "PYCHARM_RELEASE=${PYCHARM_RELEASE}" >> ${CHROOT}/opt/ide-versions
    echo "- PyCharm Community Edition __PYCHARM_VERSION__" >> ${CHROOT}/opt/ides.md
}
