function install_eclipse() {
    echo -ne "- Eclipse "

    ECLIPSE_RELEASE=2026-09
    ECLIPSE_LANGUAGES="cpp java"
    ECLIPSE_MIRROR=mirror.umd.edu

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
        tar -zxf ${tarball} --strip-components=1 -C ${ECLIPSE_DIR}/${language}
        case ${language} in
            cpp) shortcut="Eclipse-C++";;
            java) shortcut="Eclipse-Java";;
        esac
        cp ${STARTDIR}/applications/${shortcut}.desktop ${CHROOT}/usr/share/applications/
    done
    echo ""
    echo "ECLIPSE_RELEASE=${ECLIPSE_RELEASE}" >> ${CHROOT}/opt/ide-versions
    echo "- Eclipse __ECLIPSE_VERSION__ (for C/C++ and Java)" >> ${CHROOT}/opt/ides.md
}
