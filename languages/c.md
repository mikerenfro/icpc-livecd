## C

The local C compiler is `gcc` __GCC_VERSION__.

Programs are compiled with:
```
gcc __CFLAGS__ -o program program.c
```

Programs are run with:
```
./program < file.in
```

For convenience, in the `~/Desktop/test-compilers` folder, you can use the provided `Makefile_c` to compile your own submissions (e.g., `submission_a.c`) with:
```
make -f Makefile_c submission_a
```
