#!/bin/bash
HERE=$(dirname $0)
CXX=$(grep '^CXX=' ${HERE}/c++/Makefile_cpp | cut -d= -f2-)
CXXFLAGS=$(grep '^CXXFLAGS=' ${HERE}/c++/Makefile_cpp | cut -d= -f2-)
perl -p "s/__CXX__/${CXX}/g;s/__CXXFLAGS__/${CXXFLAGS}/g"