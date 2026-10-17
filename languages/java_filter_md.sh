#!/bin/bash
HERE=$(dirname $0)
JAVAC=$(grep '^JAVAC=' ${HERE}java/Makefile_java | cut -d= -f2-)
JAVACFLAGS=$(grep '^JAVACFLAGS=' ${HERE}/java/Makefile_java | cut -d= -f2-)
JAVA=$(grep '^JAVA=' ${HERE}java/Makefile_java | cut -d= -f2-)
JAVAFLAGS=$(grep '^JAVAFLAGS=' ${HERE}/java/Makefile_java | cut -d= -f2-)
perl -p "s/__JAVAC__/${JAVAC}/g;s/__JAVACFLAGS__/${JAVACFLAGS}/g;s/__JAVA__/${JAVA}/g;s/__JAVAFLAGS__/${JAVAFLAGS}/g"