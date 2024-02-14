CC=gcc
CFLAGS=-x c -g -O2 -std=gnu11 -static -lm
CXX=g++
CXXFLAGS=-x c++ -g -O2 -std=gnu++20 -static
JAVAC=javac
JAVACFLAGS=-encoding UTF-8 -sourcepath . -d .
JAVA=java
JAVAFLAGS=-Dfile.encoding=UTF-8 -XX:+UseSerialGC -Xss64m -Xms1920m -Xmx1920m
PY3=pypy3 -m py_compile
PY3FLAGS=

all: hw_icpc_c hw_icpc_cpp hw_icpc_java.class
	@echo "# Running in C"
	./hw_icpc_c
	@echo "# Running in C++"
	./hw_icpc_cpp
	@echo "# Running in Java"
	$(JAVA) $(JAVAFLAGS) hw_icpc_java
	@echo "Running in Python 3"
	$(PY3) hw_icpc_py3.py

%.class: %.java
	$(JAVAC) $(JAVACFLAGS) $<

hw_icpc_c: hw_icpc_c.c
	$(CC) $(CFLAGS) -o $@ $<

hw_icpc_cpp: hw_icpc_cpp.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

clean:
	rm -f hw_icpc_c hw_icpc_c.o hw_icpc_cpp hw_icpc_cpp.o hw_icpc_java.class
