#!/bin/bash
JAVAC=$(grep '^JAVAC=' java/Makefile_java | cut -d= -f2-)
JAVACFLAGS=$(grep '^JAVACFLAGS=' java/Makefile_java | cut -d= -f2-)
JAVA=$(grep '^JAVA=' java/Makefile_java | cut -d= -f2-)
JAVAFLAGS=$(grep '^JAVAFLAGS=' java/Makefile_java | cut -d= -f2-)
perl -p "s/__JAVAC__/${JAVAC}/g;s/__JAVACFLAGS__/${JAVACFLAGS}/g;s/__JAVA__/${JAVA}/g;s/__JAVAFLAGS__/${JAVAFLAGS}/g"