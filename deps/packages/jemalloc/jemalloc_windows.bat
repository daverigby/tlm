set INSTALL_DIR=%1

sh -c "./autogen.sh CC=cl --prefix=%INSTALL_DIR% --with-jemalloc-prefix=je_	--disable-cache-oblivious --disable-zone-allocator --enable-prof"

make build_lib_shared
make install_lib_shared install_include install_bin
