CC=gcc
CFLAGS=-x c -g -O2 -std=gnu11 -static -lm
CXX=g++
CXXFLAGS=-x c++ -g -O2 -std=gnu++20 -static
JAVAC=javac
JAVACFLAGS=-encoding UTF-8 -sourcepath . -d .
JAVA=java
JAVAFLAGS=-Dfile.encoding=UTF-8 -XX:+UseSerialGC -Xss64m -Xms1920m -Xmx1920m
PY3=pypy3 -m py_compile

all: hw_icpc_c hw_icpc_cpp hw_icpc_java.class leggjasaman_c leggjasaman_cpp leggjasaman_java.class
	@echo "# Hello, World in C"
	./hw_icpc_c
	@echo "# Hello, World in C++"
	./hw_icpc_cpp
	@echo "# Hello, World in Java"
	$(JAVA) $(JAVAFLAGS) hw_icpc_java
	@echo "Hello, World in Python 3"
	$(PY3) hw_icpc_py3.py
	@echo "# Testing Leggjasaman C against input 1"
	./leggjasaman_c < 1.in | tee 1-test.ans
	diff -u 1.ans 1-test.ans && echo passed || echo failed
	@echo "# Testing Leggjasaman C against input 2"
	./leggjasaman_c < 2.in | tee 2-test.ans
	diff -u 2.ans 2-test.ans && echo passed || echo failed
	@echo "# Testing Leggjasaman C++ against input 1"
	./leggjasaman_cpp < 1.in | tee 1-test.ans
	diff -u 1.ans 1-test.ans && echo passed || echo failed
	@echo "# Testing Leggjasaman C++ against input 2"
	./leggjasaman_cpp < 2.in | tee 2-test.ans
	diff -u 2.ans 2-test.ans && echo passed || echo failed
	@echo "# Testing Leggjasaman Java against input 1"
	$(JAVA) $(JAVAFLAGS) leggjasaman < 1.in | tee 1-test.ans
	diff -u 1.ans 1-test.ans && echo passed || echo failed
	@echo "# Testing Leggjasaman Java against input 2"
	$(JAVA) $(JAVAFLAGS) leggjasaman < 2.in | tee 2-test.ans
	diff -u 2.ans 2-test.ans && echo passed || echo failed
	@echo "# Testing Leggjasaman Python against input 1"
	$(PY3) leggjasaman_py3.py < 1.in | tee 1-test.ans
	diff -u 1.ans 1-test.ans && echo passed || echo failed
	@echo "# Testing Leggjasaman Python against input 2"
	$(PY3) leggjasaman_py3.py < 2.in | tee 2-test.ans
	diff -u 2.ans 2-test.ans && echo passed || echo failed

%_c: %_c.c
	$(CC) $(CFLAGS) -o $@ $<

%_cpp: %_cpp.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

%_java.class: %_java.java
	$(JAVAC) $(JAVACFLAGS) $<

clean:
	rm -f hw_icpc_c hw_icpc_c.o hw_icpc_cpp hw_icpc_cpp.o hw_icpc_java.class
