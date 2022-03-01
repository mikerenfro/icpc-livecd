CC=gcc
CFLAGS=-g -O2 -std=gnu11 -static -lm
CXX=g++
CXXFLAGS=-g -O2 -std=gnu++17 -static
JAVAC=javac
JAVACFLAGS=-encoding UTF-8 -sourcepath . -cp .:./* -d .
JAVA=java
JAVAFLAGS=-Dfile.encoding=UTF-8 -XX:+UseSerialGC -Xss64m -Xms1920m -Xmx1920m -cp .:./*
PY3=pypy3
PY3FLAGS=
PY2=pypy
PY2FLAGS=

all: hw_icpc_c hw_icpc_cpp hw_icpc_java.class
	@echo "C"
	./hw_icpc_c
	@echo "C++"
	./hw_icpc_cpp
	@echo "Java"
	$(JAVA) $(JAVAFLAGS) hw_icpc_java
	@echo "Python 2"
	$(PY2) hw_icpc_py2.py
	@echo "Python 3"
	$(PY3) hw_icpc_py3.py

%.class: %.java
	$(JAVAC) $(JAVACFLAGS) $<

hw_icpc_c: hw_icpc_c.c
	$(CC) $(CFLAGS) -o $@ $<

hw_icpc_cpp: hw_icpc_cpp.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

clean:
	rm -f hw_icpc_c hw_icpc_c.o hw_icpc_cpp hw_icpc_cpp.o hw_icpc_java.class
