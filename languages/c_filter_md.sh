#!/bin/bash
CC=$(grep '^CC=' c/Makefile_c | cut -d= -f2-)
CFLAGS=$(grep '^CFLAGS=' c/Makefile_c | cut -d= -f2-)
perl -p "s/__CC__/${CC}/g;s/__CFLAGS__/${CFLAGS}/g"