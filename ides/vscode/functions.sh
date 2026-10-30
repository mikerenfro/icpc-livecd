function install_ide() {
    echo "- VS Code"

    HERE=${STARTDIR}/ides/${IDE}

    (cd ${STARTDIR} && ${WGET} https://packages.microsoft.com/keys/microsoft-2025.asc)
    TRUSTED_GPG_DIR=${CHROOT}/etc/apt/trusted.gpg.d
    mkdir -p ${TRUSTED_GPG_DIR}
    gpg --dearmor < ${STARTDIR}/microsoft-2025.asc > ${TRUSTED_GPG_DIR}/packages.microsoft.gpg
    cp ${HERE}/VS-Code.desktop ${CHROOT}/usr/share/applications
    cp ${HERE}/hooks/*.hook.chroot ${WORKDIR}/config/hooks/live/
    echo "- Visual Studio Code __VSCODE_VERSION__" >> ${CHROOT}/opt/ides.md
}
