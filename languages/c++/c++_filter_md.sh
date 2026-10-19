#!/bin/bash
HERE=$(dirname $0)
CXX=$(grep '^CXX=' ${HERE}/test-compilers/Makefile_cpp | cut -d= -f2-)
CXXFLAGS=$(grep '^CXXFLAGS=' ${HERE}/test-compilers/Makefile_cpp | cut -d= -f2-)
perl -p -e "s/__CXX__/${CXX}/g;s/__CXXFLAGS__/${CXXFLAGS}/g"