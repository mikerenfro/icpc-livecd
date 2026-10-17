#!/bin/bash
PYPY=$(grep '^PY3=' python/Makefile_python | cut -d= -f2-)
perl -p "s/__PYPY__/${PYPY}/g"