## C++

The local C compiler is `__CXX__` __GPP_VERSION__.

Programs are compiled with:
```
__CXX__ __CXXFLAGS__ -o program program.cpp
```

Programs are run with:
```
./program < file.in
```

For convenience, in the `~/Desktop/test-compilers` folder, you can use the provided `Makefile_cpp` to compile your own submissions (e.g., `submission_a.cpp`) with:
```
make -f Makefile_cpp submission_a
```
