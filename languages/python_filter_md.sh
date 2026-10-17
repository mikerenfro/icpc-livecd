#!/bin/bash
HERE=$(dirname $0)
PYPY=$(grep '^PY3=' ${HERE}/python/Makefile_python | cut -d= -f2-)
perl -p -e "s/__PYPY__/${PYPY}/g"