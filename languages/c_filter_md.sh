#!/bin/bash
HERE=$(dirname $0)
CC=$(grep '^CC=' ${HERE}/c/test-compilers/Makefile_c | cut -d= -f2-)
CFLAGS=$(grep '^CFLAGS=' ${HERE}/c/test-compilers/Makefile_c | cut -d= -f2-)
perl -p -e "s/__CC__/${CC}/g;s/__CFLAGS__/${CFLAGS}/g"