#!/bin/bash
set -e

function get_debian_package_version() {
    dpkg-query -W -f='${Version}\n' $1 | egrep -o '^[0-9.]+'
}

function modify_team_readme() {
    README=/etc/skel/Desktop/README.html
    MAKEFILE=/etc/skel/Desktop/test-compilers/Makefile
    GCC_VERSION=$(get_debian_package_version gcc-14)
    GPP_VERSION=$(get_debian_package_version g++-14)
    JDK_VERSION=$(get_debian_package_version openjdk-25-jdk)
    PYPY_VERSION=$(get_debian_package_version pypy3)
    VSCODE_VERSION=$(get_debian_package_version code)
    perl -pi -e \
        "
        s/__GCC_VERSION__/${GCC_VERSION}/g;
        s/__GPP_VERSION__/${GPP_VERSION}/g;
        s/__JDK_VERSION__/${JDK_VERSION}/g;
        s/__PYPY_VERSION__/${PYPY_VERSION}/g;
        s/__ECLIPSE_VERSION__/${ECLIPSE_RELEASE}/g;
        s/__LICLIPSE_VERSION__/${LICLIPSE_RELEASE}/g;
        s/__PYCHARM_VERSION__/${PYCHARM_RELEASE}/g;
        s/__VSCODE_VERSION__/${VSCODE_VERSION}/g;
        " \
        ${README}
}

if [ -f /opt/ide-versions ]; then
    . /opt/ide-versions
fi

modify_team_readme