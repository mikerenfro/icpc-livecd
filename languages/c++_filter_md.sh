#!/bin/bash
CXX=$(grep '^CXX=' c++/Makefile_cpp | cut -d= -f2-)
CXXFLAGS=$(grep '^CXXFLAGS=' c++/Makefile_cpp | cut -d= -f2-)
perl -p "s/__CXX__/${CXX}/g;s/__CXXFLAGS__/${CXXFLAGS}/g"