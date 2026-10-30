function install_ide() {
    echo -ne "- Eclipse "

    HERE=${STARTDIR}/ides/${IDE}

    ECLIPSE_RELEASE=2026-09
    ECLIPSE_LANGUAGES="cpp java"
    ECLIPSE_MIRROR=mirror.umd.edu
    ECLIPSE_DIR=${CHROOT}/opt/eclipse

    for language in ${ECLIPSE_LANGUAGES}; do
        echo -ne "(for ${language}) "
        url=https://${ECLIPSE_MIRROR}/eclipse/technology/epp/downloads/release/${ECLIPSE_RELEASE}/R/eclipse-${language}-${ECLIPSE_RELEASE}-R-linux-gtk-x86_64.tar.gz
        (cd ${STARTDIR} && ${WGET} ${url})
        mkdir -p ${ECLIPSE_DIR}/${language}
        tarball=${STARTDIR}/$(basename ${url})
        tar -zxf ${tarball} --strip-components=1 -C ${ECLIPSE_DIR}/${language}
        case ${language} in
            cpp) shortcut="Eclipse-C++";;
            java) shortcut="Eclipse-Java";;
        esac
        cp ${HERE}/${shortcut}.desktop ${CHROOT}/usr/share/applications/
        cp ${HERE}/hooks/*.hook.chroot ${WORKDIR}/config/hooks/live/
    done
    echo ""
    echo "ECLIPSE_RELEASE=${ECLIPSE_RELEASE}" >> ${CHROOT}/opt/ide-versions
    echo "- Eclipse __ECLIPSE_VERSION__ (for C/C++ and Java)" >> ${CHROOT}/opt/ides.md
}
