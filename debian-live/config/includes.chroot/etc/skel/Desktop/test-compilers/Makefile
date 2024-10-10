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

all: hw_icpc_c hw_icpc_cpp hw_icpc_java.class leggjasaman.class leggjasaman_c leggjasaman_cpp
	@echo "# Hello, World in C"
	./hw_icpc_c
	@echo "# Hello, World in C++"
	./hw_icpc_cpp
	@echo "# Hello, World in Java"
	$(JAVA) $(JAVAFLAGS) hw_icpc_java
	@echo "Hello, World in Python 3"
	$(PY3) hw_icpc_py3.py
	@echo "# Testing Leggjasaman C against input 1"
	$(shell ./leggjasaman_c < 1.in)
	$(shell diff -u <(./leggjasaman_c < 1.in) 1.ans)
	@echo "# Testing Leggjasaman C against input 2"
	$(shell ./leggjasaman_c < 2.in)
	$(shell diff -u <(./leggjasaman_c < 2.in) 2.ans)
	@echo "# Testing Leggjasaman C++ against input 1"
	$(shell ./leggjasaman_cpp < 1.in)
	$(shell diff -u <(./leggjasaman_cpp < 1.in) 1.ans)
	@echo "# Testing Leggjasaman C++ against input 2"
	$(shell ./leggjasaman_cpp < 2.in)
	$(shell diff -u <(./leggjasaman_cpp < 2.in) 2.ans)
	@echo "# Testing Leggjasaman Java against input 1"
	$(shell $(JAVA) $(JAVAFLAGS) leggjasaman < 1.in)
	$(shell diff -u <($(JAVA) $(JAVAFLAGS) leggjasaman < 1.in) 1.ans)
	@echo "# Testing Leggjasaman Java against input 2"
	$(shell $(JAVA) $(JAVAFLAGS) leggjasaman < 2.in)
	$(shell diff -u <($(JAVA) $(JAVAFLAGS) leggjasaman < 2.in) 2.ans)
	@echo "# Testing Leggjasaman Python against input 1"
	$(shell $(PY3) leggjasaman_py3.py < 1.in)
	$(shell diff -u <($(PY3) leggjasaman_py3.py < 1.in) 1.ans)
	@echo "# Testing Leggjasaman Python against input 2"
	$(shell $(PY3) leggjasaman_py3.py < 2.in)
	$(shell diff -u <($(PY3) leggjasaman_py3.py < 2.in) 2.ans)

%.class: %.java
	$(JAVAC) $(JAVACFLAGS) $<

hw_icpc_c: hw_icpc_c.c
	$(CC) $(CFLAGS) -o $@ $<

hw_icpc_cpp: hw_icpc_cpp.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

leggjasaman_c: leggjasaman_c.c
	$(CC) $(CFLAGS) -o $@ $<

leggjasaman_cpp: leggjasaman_cpp.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

clean:
	rm -f hw_icpc_c hw_icpc_c.o hw_icpc_cpp hw_icpc_cpp.o hw_icpc_java.class
