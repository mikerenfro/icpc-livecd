#!/bin/bash
HERE=$(dirname $0)
CXX=$(grep '^CXX=' ${HERE}/c++/test-compilers/Makefile_cpp | cut -d= -f2-)
CXXFLAGS=$(grep '^CXXFLAGS=' ${HERE}/c++/test-compilers/Makefile_cpp | cut -d= -f2-)
perl -p -e "s/__CXX__/${CXX}/g;s/__CXXFLAGS__/${CXXFLAGS}/g"