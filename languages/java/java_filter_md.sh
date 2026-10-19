#!/bin/bash
HERE=$(dirname $0)
JAVAC=$(grep '^JAVAC=' ${HERE}/test-compilers/Makefile_java | cut -d= -f2-)
JAVACFLAGS=$(grep '^JAVACFLAGS=' ${HERE}/test-compilers/Makefile_java | cut -d= -f2-)
JAVA=$(grep '^JAVA=' ${HERE}/test-compilers/Makefile_java | cut -d= -f2-)
JAVAFLAGS=$(grep '^JAVAFLAGS=' ${HERE}/test-compilers/Makefile_java | cut -d= -f2-)
perl -p -e "s/__JAVAC__/${JAVAC}/g;s'__JAVACFLAGS__'${JAVACFLAGS}'g;s/__JAVA__/${JAVA}/g;s'__JAVAFLAGS__'${JAVAFLAGS}'g"
