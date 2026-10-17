## Java

The local Java compiler is OpenJDK __JDK_VERSION__.

Programs are compiled with:
```
javac -encoding UTF-8 -sourcepath . -cp ./*.class -d . program.java
```

Programs are run with:
```
java -Dfile.encoding=UTF-8 -XX:+UseSerialGC -Xss64m -Xms$(MEMLIM) -Xmx$(MEMLIM) -cp .:./*.class program < file.in
```
where `$(MEMLIM)` should be replaced with a value no higher than the designated memory limit for each problem (e.g., `1024m` for Leggja Saman).

For convenience, in the `~/Desktop/test-compilers` folder, you can use the provided `Makefile_java` to compile your own submissions (e.g., `submission_a.java`) to a class with:
```
make -f Makefile_java submission_a.class
```